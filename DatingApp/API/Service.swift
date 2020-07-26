//
//  Service.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase

struct Service {
    
    // MARK: - Load image
    
    static func uploadImage(image: UIImage, completion: @escaping(_ imageUrl: String) -> Void) {
        
        var task: StorageUploadTask!
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        let filename = NSUUID().uuidString
        let withPath = "/images/\(filename)"
        let storageRef = Storage.storage().reference(forURL: "gs://datingapp-d0f98.appspot.com").child(withPath)
        
        task = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            task.removeAllObservers()
            
            if let error = error {
                print("DEBUG: Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    static func downloadImages(imageUrls: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
        
        var imageArray: [UIImage] = []
        var downloadCounter = 0
        
        for link in imageUrls {
            
            let url = NSURL(string: link)
            DispatchQueue(label: "imageDownloadQueue").async {
                downloadCounter += 1
                let data = NSData(contentsOf: url! as URL)
                
                if data != nil {
                    
                    imageArray.append(UIImage(data: data! as Data)!)
                    if downloadCounter == imageArray.count {
                        
                        DispatchQueue.main.async {
                            completion(imageArray)
                        }
                    }
                } else {
                    print("couldnt download image")
                    completion(imageArray)
                }
            }
        }
    }
    
    // MARK: -  Save like

    static func saveLikes(forUser user: User, isLike: [String: Any]) {
                
        COLLECTION_LIKES.document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_LIKES.document(user.uid).updateData(isLike)
            } else {
                COLLECTION_LIKES.document(user.uid).setData(isLike)
            }
        }
    }

   static func saveSuperLikes(forUser user: User, isSuperLike: [String: Any]) {
                
        COLLECTION_SUPERLIKES.document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_SUPERLIKES.document(user.uid).updateData(isSuperLike)
            } else {
                COLLECTION_SUPERLIKES.document(user.uid).setData(isSuperLike)
            }
        }
    }

    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_LIKES.document(user.uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            guard let didMatch = data[currentUid] as? Bool else { return }
            completion(didMatch)
        }
    }
    
}
