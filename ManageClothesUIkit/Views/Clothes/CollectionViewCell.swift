//
//  CollectionViewCell.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        var imageview = UIImageView()
        imageview.contentMode = .scaleToFill
        imageview.frame = CGRect(x: 0, y: 0, width: screenSize.width / 3, height: screenSize.width / 3)
        return imageview
    }()
    
    var imageURLString = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
