//
//  User.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit

struct User {
    let email: String
    let uid: String
    
    init(dic: [String:Any]) {
        self.email = dic["email"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
    }
}
