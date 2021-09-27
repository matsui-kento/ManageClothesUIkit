//
//  SettingViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase

protocol BackSettingVCProtocol {
    func updateEmailAndButton(controller: UIViewController)
    func toLoginVCAfterDismiss(controller: UIViewController)
    func toRegisterVCAfterDismiss(controller: UIViewController)
}

class SettingViewController: UIViewController, BackSettingVCProtocol {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var policyButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    private var user: User?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        fetchUserFromFirestoreAndInsertEmailTextField()
        isHiddenOrNot()
        
        loginButton.layer.cornerRadius = 10
        policyButton.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
    }
    
    @IBAction func toLoginViewControllerAfterLogout(_ sender: Any) {
        do {
            let firebaseAuth = Auth.auth()
            try firebaseAuth.signOut()
            emailLabel.text = "ログインしていません。"
            toLoginVC()
        } catch let signOutError as NSError {
            print("Error siging out: %@", signOutError)
        }
    }
    
    @IBAction func toRegisterViewController(_ sender: Any) {
        toRegisterVC()
    }
    
    
    @IBAction func toLoginViewController(_ sender: Any) {
        toLoginVC()
    }
    
    private func isHiddenOrNot() {
        if Auth.auth().currentUser?.uid == nil {
            loginButton.isHidden = false
            registerButton.isHidden = false
            logoutButton.isHidden = true
        } else {
            loginButton.isHidden = true
            registerButton.isHidden = true
            logoutButton.isHidden = false
        }
    }
    
    
    private func fetchUserFromFirestoreAndInsertEmailTextField() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            emailLabel.text = "ログインしていません。"
            return
        }
        
        Firestore.fetchUser(uid: uid) { user in
            self.user = user
            self.emailLabel.text = user.email
        }
    }
    
    private func toLoginVC() {
        guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController else {
            fatalError("LoginViewController is not found")
        }
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.delegate = self
        self.present(loginVC, animated: true)
    }
    
    private func toRegisterVC() {
        guard let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "registerVC") as? RegisterViewController else {
            fatalError("RegisterViewController is not found")
        }
        registerVC.modalPresentationStyle = .fullScreen
        registerVC.delegate = self
        self.present(registerVC, animated: true)
    }
    
    //
    
    func updateEmailAndButton(controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.isHiddenOrNot()
            self.fetchUserFromFirestoreAndInsertEmailTextField()
        }
    }
    
    func toLoginVCAfterDismiss(controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.toLoginVC()
        }
    }
    
    func toRegisterVCAfterDismiss(controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.toRegisterVC()
        }
    }
}
