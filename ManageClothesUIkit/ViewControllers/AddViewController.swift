//
//  AddViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import RxSwift
import PKHUD
import RxCocoa
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet weak var kindSegmentControl: UISegmentedControl!
    @IBOutlet weak var registerImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    
    private let disposeBag = DisposeBag()
    var category: String = ""
    
    let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        imagePicker.delegate = self
    }
    
    private func setupBindings() {
        
        selectImageButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        registerImageButton.rx.tap
            .asDriver()
            .drive() { _ in
                if (self.imageView.image != UIImage(named: "plus")) && (self.category != "") {
                    self.registerClothes(category: self.category, imageString: self.imageView.image!)
                } else {
                    HUD.flash(.labeledError(title: "登録失敗", subtitle: "登録情報を全て入力してください"), delay: 3.0)
                    return
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func showImagePicker() {
        present(imagePicker, animated: true)
    }
    
    private func registerClothes(category: String, imageString: UIImage) {
        
        guard let _ = Auth.auth().currentUser?.uid else {
            HUD.flash(.labeledError(title: "ログインしてください", subtitle: "登録にはログインが必要です"), delay: 3.0)
            return
        }
        
        HUD.show(.progress)
        Firestore.setClothes(category: category, imageString: imageString) { success in
            HUD.hide()
            if success {
                HUD.flash(.success, delay: 1.0) { _ in
                    self.imageView.image = UIImage(named: "plus")
                }
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        }
    }
    
    private func loginOrNot() {
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
