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
    private let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    private var clothes: Clothes?
    static var clothesArray = [Clothes]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ClothesViewController.clothesArray = []

        if (Auth.auth().currentUser?.uid) != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            HUD.show(.progress)
            Firestore.fetchClothesArray(uid: uid) { clothesArray in
                HUD.hide()
                ClothesViewController.clothesArray = clothesArray
                print("ClothesのArrayの取得に成功しました")
                self.collectionView.reloadData()
            }
        }
    }
    
    private func fetchClothes(uid: String) {
        Firestore.fetchClothesArray(uid: uid) { clothesArray in
            ClothesViewController.clothesArray = clothesArray
            print("ClothesのArrayの取得に成功しました")
        }
    }
}

extension ClothesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ClothesViewController.clothesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("CollectionViewCell is not found")
        }
        cell.imageView.sd_setImage(with: URL(string: ClothesViewController.clothesArray[indexPath.row].imageURLString), completed: nil)
        return cell
    }
}


extension ClothesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.imageURLString = ClothesViewController.clothesArray[indexPath.row].imageURLString
        detailVC.documentID = ClothesViewController.clothesArray[indexPath.row].documentID
        detailVC.index = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension ClothesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenSize.width / 3, height: screenSize.width / 3)
    }
}
