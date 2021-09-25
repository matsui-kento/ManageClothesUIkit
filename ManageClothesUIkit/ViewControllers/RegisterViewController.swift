//
//  RegisterViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase
import RxSwift
import PKHUD

class RegisterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var haveAcountButton: UIButton!
    @IBOutlet weak var dontCreateButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
    }
    
    private func setupBindings() {
        
        let emailValidation = self.emailTextField
            .rx.text
            .map({ ($0?.isValidEmail())! })
            .share(replay: 1)
        
        let passwordValidation = passwordTextField
            .rx.text
            .map({(($0 ?? "").count >= 6)})
            .share(replay: 1)
        
        
        let enableButton = Observable.combineLatest(emailValidation, passwordValidation) { $0 && $1 }
            .share(replay: 1)
        
        enableButton
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.createUser()
            }
            .disposed(by: disposeBag)
        
        dontCreateButton.rx.tap
            .asDriver()
            .drive() { _ in
                let mainVC = MainTabBarController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        haveAcountButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func createUser() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        HUD.show(.progress)
        Auth.createUserWithFirestore(email: email, password: password) { success in
            HUD.hide()
            if success {
                print("ユーザーのAuthentication,Firestoreへの保存が完了しました。")
                HUD.flash(.success, delay: 1.0) { _ in
                    let mainVC = MainTabBarController()
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            } else {
                HUD.flash(.labeledError(title: "登録失敗", subtitle: "メールアドレスが既に使われています。"), delay: 3.0)
                print("ユーザーのAuthentication,Firestoreへの保存が失敗しました。")
            }
        }
    }
}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

