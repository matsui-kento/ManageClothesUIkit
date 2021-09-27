//
//  Clothes.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import Foundation

struct Clothes {
    
    let category: String
    let imageURLString: String
    let documentID: String
    
    init(dic: [String:Any]) {
        self.category = dic["category"] as? String ?? ""
        self.imageURLString = dic["imageURLString"] as? String ?? ""
        self.documentID = dic["documentID"] as? String ?? ""
    }
}
