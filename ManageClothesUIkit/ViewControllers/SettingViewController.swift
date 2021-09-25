//
//  SettingViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import RxCocoa
import RxSwift
import Firebase

class SettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var policyButton: UIButton!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        fetchUser()
        
        if Auth.auth().currentUser?.uid == nil {
            loginButton.isHidden = false
        } else {
            loginButton.isHidden = true
        }
        
        loginButton.layer.cornerRadius = 10
        policyButton.layer.cornerRadius = 10
        logoutButton.layer.cornerRadius = 10
    }
    
    private func setupBindings() {
        
        logoutButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.logout()
            }
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.logout()
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.fetchUserFromFirestore(uid: uid) { user in
            self.user = user
            self.emailLabel.text = user.email
        }
    }
    
    private func login() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    private func logout() {
        do {
            let firebaseAuth = Auth.auth()
            try firebaseAuth.signOut()
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        } catch let signOutError as NSError {
            print("Error siging out: %@", signOutError)
        }
    }
}
