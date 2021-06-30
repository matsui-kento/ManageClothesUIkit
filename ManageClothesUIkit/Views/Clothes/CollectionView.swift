//
//  CollectionView.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit

class CollectionView: UICollectionView {
    let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        backgroundColor = UIColor.white
        register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
