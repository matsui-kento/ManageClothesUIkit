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


class ClothesViewController: UIViewController {
    
    private var clothesArray: [Clothes] = []
    private var filterdClothesArray: [Clothes] = []
    private var categories = ["all", "tops", "bottoms", "other"]
    
    @IBOutlet weak var kindSegmentControl: UISegmentedControl!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllClothes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self

        collectionViewFlowLayout.estimatedItemSize = CGSize(width: imageCollectionView.frame.width / 3, height: imageCollectionView.frame.width / 3)
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
    }
    
    private func fetchAllClothes() {
        guard let uid = Auth.auth().currentUser?.uid else {
            filterdClothesArray = []
            updatedCollectionView()
            return
        }
        
        Firestore.fetchClothesArray(uid: uid) { clothesArray in
            self.clothesArray = clothesArray
            self.filterdClothesArray = clothesArray
            self.updatedCollectionView()
        }
    }
    
    private func updatedCollectionView() {
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let detailVC = segue.destination as? DetailViewController,
                  let indexPath = imageCollectionView.indexPathsForSelectedItems?.first else {
                fatalError("DetailViewController is not found")
            }
            
            let clothes = clothesArray[indexPath.row]
            detailVC.imageURLString = clothes.imageURLString
        }
    }
    
    @IBAction func categoryValueChanged(segmentedControl: UISegmentedControl) {
        let category = categories[segmentedControl.selectedSegmentIndex]
        filterClothes(by: category)
    }
    
    private func filterClothes(by category: String?) {
        if category == nil || category == "all" {
            self.filterdClothesArray = self.clothesArray
            self.updatedCollectionView()
        } else {
            self.filterdClothesArray = self.clothesArray.filter { $0.category == category }
            self.updatedCollectionView()
        }
    }
}

extension ClothesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterdClothesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("ImageCollectionViewCell is not found")
        }
        cell.imageView.sd_setImage(with: URL(string: self.filterdClothesArray[indexPath.row].imageURLString), completed: nil)

        return cell
    }
}
