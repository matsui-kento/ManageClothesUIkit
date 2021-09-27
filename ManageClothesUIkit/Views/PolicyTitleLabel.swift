//
//  PolicyTitleLabel.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/24.
//

import UIKit

class PolicyTitleLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 20, weight: .bold)
        text = title
        textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
