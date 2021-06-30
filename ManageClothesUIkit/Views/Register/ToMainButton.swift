//
//  ToMainButton.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/28.
//

import UIKit

class ToMainButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .init(red: 0, green: 0, blue: 0, alpha: 0.4) : .init(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        titleLabel?.font = .systemFont(ofSize: 23, weight: .semibold)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
