//
//  FilterButton.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/23.
//

import UIKit

class FilterButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? .init(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.5) : .init(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        }
    }
    
    init(category: String) {
        super.init(frame: .zero)
        tintColor = .black
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        backgroundColor = .init(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        layer.cornerRadius = 20
        setTitle(category, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
