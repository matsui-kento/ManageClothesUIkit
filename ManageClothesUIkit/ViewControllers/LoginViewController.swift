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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAcountButton: UIButton!
    @IBOutlet weak var dontCreateUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
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
                let mainVC = MainTabBarController()
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
                    let mainVC = MainTabBarController()
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
