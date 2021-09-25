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
    private let categories = ["tops", "bottoms", "other"]
    private var category: String = "tops"
    private var image: UIImage?
    
    private let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        imagePicker.delegate = self
        selectImageButton.layer.cornerRadius = 10
        registerImageButton.layer.cornerRadius = 10
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
                if self.image != nil && self.category != "" {
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
            HUD.flash(.labeledError(title: "ログインしてください", subtitle: "登録にはログインが必要です"), delay: 2.0)
            return
        }
        
        HUD.show(.progress)
        Firestore.setClothes(category: category, imageString: imageString) { success in
            HUD.hide()
            if success {
                HUD.flash(.success, delay: 1.0) { _ in
                    self.imageView.image = UIImage(named: "plus")
                    self.image = nil
                }
            } else {
                HUD.flash(.error, delay: 1.0)
            }
        }
    }
    
    @IBAction func categoryValueChanged(segmentedControl: UISegmentedControl) {
        category = categories[segmentedControl.selectedSegmentIndex]
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[.editedImage] as? UIImage
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
