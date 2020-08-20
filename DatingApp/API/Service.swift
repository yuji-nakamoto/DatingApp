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
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
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
    
    // MARK: - Swipe
    
    static func saveSwipe(toUserId: String) {
        
        COLLECTION_SWIPE.document(User.currentUserId()).getDocument { (snapshot, error) in
            let data = [toUserId: true]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPE.document(User.currentUserId()).updateData(data)
            } else {
                COLLECTION_SWIPE.document(User.currentUserId()).setData(data)
            }
        }
    }

    static func fetchSwipe(completion: @escaping([String: Bool]) -> Void) {
                
        COLLECTION_SWIPE.document(User.currentUserId()).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
}
