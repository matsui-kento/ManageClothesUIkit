//
//  CategoryLabel.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/18.
//

import UIKit

class CategoryLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        text = "カテゴリーを選択する"
        font = UIFont.boldSystemFont(ofSize: 18)
        textColor = UIColor.black
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
