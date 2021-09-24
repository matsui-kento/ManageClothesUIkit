//
//  PolicyTextView.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/19.
//

import UIKit

class PolicyTextView: UITextView {
    
    init(policyText: String) {
        super.init(frame: CGRect.zero, textContainer: nil)
        text = policyText
        isEditable = false
        isSelectable = false
        font = UIFont.boldSystemFont(ofSize: 15)
        textColor = .black
        tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
