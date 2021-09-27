//
//  Firebase+Extension.swift
//  ManageClothesUIkit
//
//  Created by matsui kento on 2021/06/15.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

extension Auth {
    
    static func createUserWithFirestore(email: String?, password: String?, completion: @escaping (Bool) -> Void) {
        
        guard let email = email else { return }
        guard let password = password else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                print("新規ユーザーの登録に失敗しました。")
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            Firestore.setUser(email: email, uid: uid) { success in
                completion(success)
            }
        }
    }
    
    static func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("ログインに失敗しました")
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            print("ログインに成功しました")
            completion(true)
        }
    }
}

extension Firestore {
    
    static func setUser(email: String, uid: String, completion: @escaping (Bool) -> ()) {
        
        let dictionary: [String:Any] = ["email": email, "uid" : uid]
        let docRef = Firestore.firestore().collection("Users").document(uid)
        docRef.setData(dictionary) { error in
            if let error = error {
                print("新規ユーザー情報の保存に失敗しました。")
                print(error.localizedDescription)
                return
            }
            print("新規ユーザー情報の保存に成功しました。")
            completion(true)
        }
    }
    
    static func setClothes(category: String, imageString: UIImage, completion: @escaping (Bool) -> ()) {
        
        Storage.setClothesImageWithFireStorage(imageString: imageString) { imageURLString in
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let docRef = Firestore.firestore().collection("Users").document(uid).collection("Clothes").document()
            let data: [String:Any] = ["category": category,
                                      "imageURLString": imageURLString,
                                      "documentID": docRef.documentID]
            
            docRef.setData(data) { error in
                if let error = error {
                    print("画像のFirestoreへの保存が失敗しました")
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                print("画像のFirestoreへの保存が成功しました")
                completion(true)
            }
        }
    }
    
    static func fetchClothesArray(uid: String, completion: @escaping ([Clothes]) -> ()) {

        let docRef = Firestore.firestore().collection("Users").document(uid).collection("Clothes")
        docRef.addSnapshotListener { snapshots, error in
            if let error = error {
                print("ClothesのArrayの取得に失敗しました。")
                print(error.localizedDescription)
                return
            }

            let clothesArray = snapshots?.documents.map({ snapshot -> Clothes in
                let data = snapshot.data()
                let clothes = Clothes(dic: data)
                return clothes
            })

            completion(clothesArray ?? [Clothes]())
        }
    }
    
    static func deleteClothesFromFirestore(uid: String, documentID: String, completion: @escaping (Bool) -> ()) {
        
        let docRef = Firestore.firestore().collection("Users").document(uid).collection("Clothes").document(documentID)
        docRef.delete { error in
            if let error = error {
                print("Clothesの削除に失敗しました。")
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            print("Clothesの削除に成功しました。")
        }
    }
    
    static func fetchUser(uid: String, completion: @escaping (User) -> ()) {
        
        let docRef = Firestore.firestore().collection("Users").document(uid)
        
        docRef.getDocument { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = snapShot?.data() else { return }
            let user = User(dic: data)
            print(user)
            completion(user)
        }
    }
}

extension Storage {
    
    static func setClothesImageWithFireStorage(imageString: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = imageString.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Clothes").child(filename)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            
            if let error = error {
                print("画像のStorageへの保存が失敗しました。")
                print(error.localizedDescription)
                return
            }
            
            print("画像のStorageへの保存が成功しました。")
            
            storageRef.downloadURL { url, error in
                
                if let error = error {
                    print("Storageから画像URLの取得に失敗しました。")
                    print(error.localizedDescription)
                    return
                }
                
                print("Storageから画像URLの取得に成功しました。")
                
                guard let imageURLString = url?.absoluteString else { return }
                completion(imageURLString)
            }
        }
    }
}
