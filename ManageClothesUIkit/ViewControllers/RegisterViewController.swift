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
    private let registerButton = RegisterButton(text: "新規登録")
    private let titleLabel = RegisterTitleLabel(text: "新規登録")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password(6文字以上)")
    private let haveAcountButton = HaveAcountButton(text: "既にアカウントをお持ちの場合はこちら")
    private let dontCreateUser = HaveAcountButton(text: "アカウントを作らずにアプリのなかを見たい人はこちら")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        passwordTextField.isSecureTextEntry = true
        let textFieldStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        textFieldStackView.axis = .vertical
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 25
        
        view.addSubview(textFieldStackView)
        view.addSubview(registerButton)
        view.addSubview(titleLabel)
        view.addSubview(haveAcountButton)
        view.addSubview(dontCreateUser)
        
        emailTextField.anchor(height: 50)
        textFieldStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 40, rightPadding: 40)
        registerButton.anchor(top: textFieldStackView.bottomAnchor, centerX: view.centerXAnchor, width: 200, height: 60, topPadding: 30)
        titleLabel.anchor(bottom: textFieldStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 30)
        haveAcountButton.anchor(bottom: dontCreateUser.topAnchor, centerX: view.centerXAnchor, bottomPadding: 15)
        dontCreateUser.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, bottomPadding: 30)
        
        view.backgroundColor = .brown
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
        
        dontCreateUser.rx.tap
            .asDriver()
            .drive() { _ in
                let mainVC = MainTabViewController()
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
                    let mainVC = MainTabViewController()
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

