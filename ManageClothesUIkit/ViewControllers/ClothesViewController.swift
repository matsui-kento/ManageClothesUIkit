//
//  ViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase
import PKHUD
import SDWebImage
import RxSwift


class ClothesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var clothesArray: [Clothes] = []
    @IBOutlet weak var kindSegmentControl: UISegmentedControl!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        fetchAllClothes()
    }
    
    private func fetchAllClothes() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.fetchClothesArray(uid: uid) { clothesArray in
            print(clothesArray)
            self.clothesArray = clothesArray
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
        }
        
    }
}

extension ClothesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clothesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("ImageCollectionViewCell is not found")
        }
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath)
        
//        cell.imageView.sd_setImage(with: URL(string: self.clothesArray[indexPath.row].imageURLString), completed: nil)
        
        return cell
    }
}
