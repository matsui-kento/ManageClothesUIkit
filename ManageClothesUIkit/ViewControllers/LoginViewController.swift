//
//  LoginViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase
import RxSwift
import PKHUD

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let loginButton = RegisterButton(text: "ログイン")
    private let titleLabel = RegisterTitleLabel(text: "ログイン")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password(6文字以上)")
    private let dontHaveAcountButton = HaveAcountButton(text: "まだアカウントを持っていない方はこちら")
    private let dontCreateUser = HaveAcountButton(text: "アカウントを作らずにアプリのなかを見たい人はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        navigationController?.isNavigationBarHidden = true
        
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
        view.addSubview(loginButton)
        view.addSubview(titleLabel)
        view.addSubview(dontHaveAcountButton)
        view.addSubview(dontCreateUser)
        
        emailTextField.anchor(height: 50)
        textFieldStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 40, rightPadding: 40)
        loginButton.anchor(top: textFieldStackView.bottomAnchor, centerX: view.centerXAnchor, width: 200, height: 60, topPadding: 30)
        titleLabel.anchor(bottom: textFieldStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 30)
        dontHaveAcountButton.anchor(bottom: dontCreateUser.topAnchor, centerX: view.centerXAnchor, bottomPadding: 15)
        dontCreateUser.anchor(bottom: view.bottomAnchor, centerX: view.centerXAnchor, bottomPadding: 30)
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
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.login()
            }
            .disposed(by: disposeBag)
        
        dontCreateUser.rx.tap
            .asDriver()
            .drive() { _ in
                let mainVC = MainTabViewController()
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        dontHaveAcountButton.rx.tap
            .asDriver()
            .drive() { _ in
                let registerVC = RegisterViewController()
                self.navigationController?.pushViewController(registerVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func login() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        HUD.show(.progress)
        
        Auth.loginUser(email: email, password: password) { success in
            HUD.hide()
            if success {
                HUD.flash(.success, delay: 1.0) { _ in
                    let mainVC = MainTabViewController()
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            } else {
                HUD.flash(.labeledError(title: "ログイン失敗", subtitle: "メールアドレスもしくはパスワードが間違えています。"), delay: 3.0)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
