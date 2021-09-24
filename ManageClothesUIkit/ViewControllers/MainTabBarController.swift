//
//  MainTabViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func setupTab() {
        let clothesVC = ClothesViewController()
        clothesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)


        let addVC = AddViewController()
        addVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)

        let settingVC = SettingViewController()
        settingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)

        viewControllers = [clothesVC, addVC, settingVC]
    }

}
