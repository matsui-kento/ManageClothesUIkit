//
//  RegisterViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import PKHUD

class RegisterViewController: UIViewController {
    
    var delegate: BackSettingVCProtocol?
    private let loginViewModel = LoginAndRegisterViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var haveAcountButton: UIButton!
    @IBOutlet weak var dontCreateButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        registerButton.layer.cornerRadius = 10
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
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginViewModel.isValid()
            .map { $0 ? 1 : 0.3 }
            .bind(to: registerButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
    @IBAction func registerUser(_ sender: Any) {
        registerUser()
    }
    
    @IBAction func toLoginVC(_ sender: Any) {
        delegate?.toLoginVCAfterDismiss(controller: self)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func registerUser() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        HUD.show(.progress)
        Auth.createUserWithFirestore(email: email, password: password) { success in
            HUD.hide()
            if success {
                print("ユーザーのAuthentication,Firestoreへの保存が完了しました。")
                HUD.flash(.success, delay: 1.0) { _ in
                    self.delegate?.updateEmailAndButton(controller: self)
                }
            } else {
                HUD.flash(.labeledError(title: "登録失敗", subtitle: "メールアドレスが既に使われています。"), delay: 1.5)
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

