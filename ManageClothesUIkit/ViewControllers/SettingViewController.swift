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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var policyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        if Auth.auth().currentUser?.uid == nil {
            loginButton.isHidden = false
        } else {
            loginButton.isHidden = true
        }
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
