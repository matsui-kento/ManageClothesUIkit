//
//  LoginViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase
import PKHUD
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    var delegate: BackSettingVCProtocol?
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAcountButton: UIButton!
    @IBOutlet weak var dontCreateUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        loginButton.layer.cornerRadius = 10
        emailTextField.becomeFirstResponder()
    }
    
    private func setupBindings() {
        emailTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: loginViewModel.emailTextPublishSubject)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: loginViewModel.passwordTextPublishSubject)
            .disposed(by: disposeBag)
        
        loginViewModel.isValid()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel.isValid()
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    @IBAction func toRegisterVC(_ sender: Any) {
        delegate?.toRegisterVCAfterDismiss(controller: self)
    }
    
    @IBAction func login(_ sender: Any) {
        login()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func login() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        HUD.show(.progress)

        Auth.loginUser(email: email, password: password) { success in
            HUD.hide()
            if success {
                HUD.flash(.success, delay: 1.0) { _ in
                    self.delegate?.updateEmailAndButton(controller: self)
                }
            } else {
                HUD.flash(.labeledError(title: "ログイン失敗", subtitle: "メールアドレスもしくはパスワードが間違えています。"), delay: 1.5)
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
