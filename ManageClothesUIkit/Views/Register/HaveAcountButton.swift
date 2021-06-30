//
//  HaveAcountButton.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit

class HaveAcountButton: UIButton {
    
    init(text: String) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
