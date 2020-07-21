//
//  Service.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import FirebaseStorage

struct Service {
    
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
}
