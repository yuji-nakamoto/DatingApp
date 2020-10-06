//
//  Like.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Like {
    
    var uid: String!
    var isLike: Int!
    var timestamp: Timestamp!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        self.uid = dict[UID] as? String ?? ""
        self.isLike = dict[ISLIKE] as? Int ?? 0
        self.timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
    }
    
    // MARK: - Fetch isLike user
    
    class func fetchLikeUser(_ forUserId: String, completion: @escaping(_ like: Like) -> Void) {
        
        COLLECTION_LIKE.document(User.currentUserId()).collection(ISLIKE).document(forUserId).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard snapshot?.data() != nil else { return }
            let like = Like(dict: snapshot!.data()! as [String: Any])
            completion(like)
        }
    }
    
    class func fetchLikeUsers(completion: @escaping(Like) -> Void) {
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            COLLECTION_LIKE.document(User.currentUserId()).collection(ISLIKE).order(by: TIMESTAMP).limit(to: 5).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription) ")
                }
                
                if snapshot?.documents == [] {
                    completion(Like(dict: [UID: ""]))
                }
                snapshot?.documents.forEach({ (document) in
                    let dict = document.data()
                    let like = Like(dict: dict)
                    guard blockUserIDs[like.uid] == nil else { return }
                    completion(like)
                })
            }
        }
    }
    
    // MARK: - Fetch liked user
    
    class func fetchLikedUsers(completion: @escaping(Like) -> Void) {
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            COLLECTION_LIKE.document(User.currentUserId()).collection(LIKED).order(by: TIMESTAMP).limit(to: 5).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription) ")
                }
                
                if snapshot?.documents == [] {
                    completion(Like(dict: [UID: ""]))
                }
                snapshot?.documents.forEach({ (document) in
                    let dict = document.data()
                    let like = Like(dict: dict)
                    guard blockUserIDs[like.uid] == nil else { return }
                    completion(like)
                })
            }
        }
    }
    
    // MARK: - Save
    
    class func saveIsLikeUser(forUser user: User, isLike: [String: Any]) {
        
        COLLECTION_LIKE.document(User.currentUserId()).collection(ISLIKE).document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_LIKE.document(User.currentUserId()).collection(ISLIKE).document(user.uid).updateData(isLike)
            } else {
                COLLECTION_LIKE.document(User.currentUserId()).collection(ISLIKE).document(user.uid).setData(isLike)
            }
        }
    }
    
    class func saveLikedUser(forUser user: User) {
        
        COLLECTION_LIKE.document(user.uid).collection(LIKED).document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let dict = [UID: User.currentUserId(), TIMESTAMP: Timestamp(date: Date())] as [String : Any]

            if snapshot?.exists == true {
                COLLECTION_LIKE.document(user.uid).collection(LIKED).document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_LIKE.document(user.uid).collection(LIKED).document(User.currentUserId()).setData(dict)
            }
        }
    }
}
