//
//  LogoutButton.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/19.
//

import UIKit

class LogoutButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .init(red: 255, green: 0, blue: 0, alpha: 0.5) : .init(red: 255, green: 0, blue: 0, alpha: 1)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        setTitle("ログアウト", for: .normal)
        tintColor = .black
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        backgroundColor = .init(red: 255, green: 0, blue: 0, alpha: 1)
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
