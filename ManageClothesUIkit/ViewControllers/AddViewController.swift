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
import YSRadioButton

class AddViewController: UIViewController {
    
    
    private let disposeBag = DisposeBag()
    private let pickerButton = PickerButton()
    private let registerItemButton = RegisterItemButton()
    private let imageView = AddImageView()
    private let categoryLabel = CategoryLabel()
    var category: String = ""
    private let categories = ["tops", "bottoms", "other"]
    private let radioButton = YSRadioButtonViewController(labels: ["tops", "bottoms", "other"])
    
    let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupRadioButton()
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        imagePicker.delegate = self
        
        pickerButton.anchor(height: 50)
        registerItemButton.anchor(height: 50)
        categoryLabel.anchor(height: 50)
        radioButton.view.anchor(height: 100)
        let stackView = UIStackView(arrangedSubviews: [radioButton.view, pickerButton, registerItemButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        view.addSubview(imageView)
        
        stackView.anchor(bottom: view.bottomAnchor ,left: view.leftAnchor, right: view.rightAnchor, bottomPadding: 100 ,leftPadding: 40, rightPadding: 40)
        imageView.anchor(bottom: stackView.topAnchor, centerX: view.centerXAnchor, width: 250, height: 250, bottomPadding: 30)
    }
    
    private func setupRadioButton() {
        radioButton.delegate = self
        radioButton.font = UIFont.systemFont(ofSize: 18)
        radioButton.labelColor = .black
        radioButton.radioHeadStroke = .darkGray
        radioButton.radioHeadFill = .black
        addChild(radioButton)
        radioButton.didMove(toParent: self)
    }
    
    private func setupBindings() {
        
        pickerButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.showImagePicker()
            }
            .disposed(by: disposeBag)
        
        registerItemButton.rx.tap
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

extension AddViewController: YSRadioButtonViewControllerDelegate {
    func didYSRadioButtonSelect(no: Int) {
        self.category = categories[no]
    }
}
