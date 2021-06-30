//
//  DetailImageView.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/19.
//

import UIKit

class DetailImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        //image = UIImage(named: "plus")
        contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
