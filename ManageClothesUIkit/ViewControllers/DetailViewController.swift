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

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var imageURLString: String!
    var documentID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        detailImageView.sd_setImage(with: URL(string: imageURLString), completed: nil)
        deleteButton.layer.cornerRadius = 10
    }
    
    @IBAction func deleteClothes(_ sender: Any) {
        deleteClothes()
    }
    
    func deleteClothes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.deleteClothesFromFirestore(uid: uid, documentID: documentID) { success in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                fatalError("写真を削除できませんでした。")
            }
        }
    }
    
}
