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
    private let logoutButton = LogoutButton()
    private let loginButton = LoginButton()
    private let policyButton = PolicyButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        
        let stackView: UIStackView
        
        if Auth.auth().currentUser?.uid == nil {
            stackView = UIStackView(arrangedSubviews: [policyButton, loginButton])
        } else {
            stackView = UIStackView(arrangedSubviews: [policyButton, logoutButton])
        }
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        view.addSubview(stackView)
        logoutButton.anchor(height: 50)
        loginButton.anchor(height: 50)
        stackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor , leftPadding: 40, rightPadding: 40)
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
        
        policyButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.toPolicy()
            }
            .disposed(by: disposeBag)
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
    
    private func toPolicy() {
        let policyVC = PolicyViewController()
        self.navigationController?.pushViewController(policyVC, animated: true)
    }
}
