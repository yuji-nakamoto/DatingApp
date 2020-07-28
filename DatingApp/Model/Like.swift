//
//  Like.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

class Like {
    var name: String!
    var age: String!
    var residence: String!
    var profileImageUrl: String!
    var uid: String!
    var isLike: Int!
    var selfIntro: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        self.name = dict[USERNAME] as? String ?? ""
        self.profileImageUrl = dict[PROFILEIMAGEURL1] as? String ?? ""
        self.uid = dict[UID] as? String ?? ""
        self.age = dict[AGE] as? String ?? ""
        self.residence = dict[RESIDENCE] as? String ?? ""
        self.isLike = dict[ISLIKE] as? Int ?? 0
        self.selfIntro = dict[SELFINTRO] as? String ?? ""
    }
    
    // MARK: - Fetch isLike user
    
    class func fetchLikeUser(_ forUserId: String, completion: @escaping(_ like: Like) -> Void) {
        
        COLLECTION_LIKE.document(User.currentUserId()).collection("isLike").document(forUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard snapshot?.data() != nil else { return }
            let like = Like(dict: snapshot!.data()! as [String: Any])
            completion(like)
        }
    }
    
    class func fetchLikeUsers(completion: @escaping(Like) -> Void) {

        COLLECTION_LIKE.document(User.currentUserId()).collection("isLike").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
//                print("DEBUG: fetchLikeUsers document data\(document.data())")
                let dict = document.data()
                let like = Like(dict: dict)
                completion(like)
            })
        }
    }
    
    // MARK: - Fetch liked user
    
    class func fetchLikedUser(completion: @escaping(Like) -> Void) {
        
        COLLECTION_LIKE.document(User.currentUserId()).collection("liked").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
//                print("DEBUG: fetchLiked document data\(document.data())")
                let like = Like(dict: dict)
                completion(like)
            })
        }
    }
    
    // MARK: - Save
    
    class func saveIsLikeUser(forUser user: User, isLike: [String: Any]) {
                
        COLLECTION_LIKE.document(User.currentUserId()).collection("isLike").document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_LIKE.document(User.currentUserId()).collection("isLike").document(user.uid).updateData(isLike)
            } else {
                COLLECTION_LIKE.document(User.currentUserId()).collection("isLike").document(user.uid).setData(isLike)
            }
        }
    }
    
    class func saveLikedUser(forUser user: User) {
                
        COLLECTION_LIKE.document(user.uid).collection("liked").document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let dict = [UID: User.currentUserId()]
            
            if snapshot?.exists == true {
                COLLECTION_LIKE.document(user.uid).collection("liked").document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_LIKE.document(user.uid).collection("liked").document(User.currentUserId()).setData(dict)
            }
        }
    }
}
