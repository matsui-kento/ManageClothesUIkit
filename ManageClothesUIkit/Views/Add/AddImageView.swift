//
//  AddImageView.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/18.
//

import UIKit

class AddImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        image = UIImage(named: "plus")
        contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
