//
//  DetailViewController.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import UIKit
import Firebase
import SDWebImage
import PKHUD
import RxSwift

class DetailViewController: UIViewController {

    private let disposeBag = DisposeBag()
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var imageURLString: String = ""
    var documentID: String = ""
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupBindings()
    }
    
    private func setupLayout() {
        detailImageView.sd_setImage(with: URL(string: imageURLString), completed: nil)
        deleteButton.layer.cornerRadius = 10
    }
    
    private func setupBindings() {
        deleteButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.deleteClothes()
            }
            .disposed(by: disposeBag)
            
    }
    
    func deleteClothes() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        Firestore.deleteClothesFromFirestore(uid: uid, documentID: documentID) { success in
//            if success {
//                HUD.flash(.success, delay: 1.0)
//                ClothesViewController.clothesArray.remove(at: self.index)
//                print(ClothesViewController.clothesArray)
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//
    }
    
}
