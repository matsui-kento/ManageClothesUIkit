//
//  RegisterTitleLabel.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit

class RegisterTitleLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: 35, weight: .heavy)
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
