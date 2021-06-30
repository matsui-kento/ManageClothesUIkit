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
    private let detailButton = DeleteButton()
    private let detailImageView = DetailImageView()
    var imageURLString: String = ""
    var documentID: String = ""
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupLayout() {
        
        detailImageView.sd_setImage(with: URL(string: imageURLString), completed: nil)
        view.addSubview(detailButton)
        view.addSubview(detailImageView)
        detailButton.anchor(top: detailImageView.bottomAnchor ,left: view.leftAnchor, right: view.rightAnchor, height: 50, topPadding: 50, leftPadding: 40, rightPadding: 40)
        detailImageView.anchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor, width: 250, height: 250)
    }
    
    private func setupBindings() {
        detailButton.rx.tap
            .asDriver()
            .drive() { _ in
                self.deleteClothes()
            }
            .disposed(by: disposeBag)
            
    }
    
    func deleteClothes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.deleteClothesFromFirestore(uid: uid, documentID: documentID) { success in
            if success {
                HUD.flash(.success, delay: 1.0)
                ClothesViewController.clothesArray.remove(at: self.index)
                print(ClothesViewController.clothesArray)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
