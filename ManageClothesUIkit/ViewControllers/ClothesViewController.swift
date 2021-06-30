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
    private let collectionView = CollectionView()
    private let allButton = FilterButton(category: "all")
    private let topsButton = FilterButton(category: "tops")
    private let bottomsButton = FilterButton(category: "bottoms")
    private let otherButton = FilterButton(category: "other")
    static var clothesArray = [Clothes]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
            collectionView.delegate = self
            collectionView.dataSource = self
            
            setupLayout()
            setupBindings()
        
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
    
    private func setupLayout() {
        let filterButtonFirstStackView = UIStackView(arrangedSubviews: [allButton, topsButton])
        let filterButtonSecondStackView = UIStackView(arrangedSubviews: [bottomsButton, otherButton])
        let filterStackView = UIStackView(arrangedSubviews: [filterButtonFirstStackView, filterButtonSecondStackView])
        let baseStackView = UIStackView(arrangedSubviews: [filterStackView, collectionView])
        filterButtonFirstStackView.axis = .horizontal
        filterButtonSecondStackView.axis = .horizontal
        baseStackView.axis = .vertical
        filterStackView.axis = .vertical
        baseStackView.spacing = 20
        filterStackView.spacing = 10
        filterButtonFirstStackView.spacing = 20
        filterButtonSecondStackView.spacing = 20
        baseStackView.alignment = .center
        filterStackView.alignment = .center
        filterButtonFirstStackView.distribution = .fillEqually
        filterButtonSecondStackView.distribution = .fillEqually
        view.addSubview(baseStackView)
        allButton.anchor(width: 120)
        bottomsButton.anchor(width: 120)
        collectionView.anchor(left: view.leftAnchor, right: view.rightAnchor)
        baseStackView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, topPadding: 50)
    }
    
    private func setupBindings() {
        
        allButton.rx.tap
            .asDriver()
            .drive() { _ in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self.fetchClothes(uid: uid)
                print(ClothesViewController.clothesArray)
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        topsButton.rx.tap
            .asDriver()
            .drive() { _ in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self.fetchClothes(uid: uid)
                ClothesViewController.clothesArray = ClothesViewController.clothesArray.filter { $0.category == "tops" }
                print(ClothesViewController.clothesArray)
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        bottomsButton.rx.tap
            .asDriver()
            .drive() { _ in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self.fetchClothes(uid: uid)
                ClothesViewController.clothesArray = ClothesViewController.clothesArray.filter { $0.category == "bottoms" }
                print(ClothesViewController.clothesArray)
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        otherButton.rx.tap
            .asDriver()
            .drive() { _ in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self.fetchClothes(uid: uid)
                ClothesViewController.clothesArray = ClothesViewController.clothesArray.filter { $0.category == "other" }
                print(ClothesViewController.clothesArray)
                self.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
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
