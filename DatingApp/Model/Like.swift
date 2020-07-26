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
    
    init() {
    }
    
    init(dict: [String: Any]) {
        self.name = dict[USERNAME] as? String ?? ""
        self.profileImageUrl = dict[PROFILEIMAGEURL1] as? String ?? ""
        self.uid = dict[UID] as? String ?? ""
        self.age = dict[AGE] as? String ?? ""
        self.residence = dict[RESIDENCE] as? String ?? ""
        self.isLike = dict[ISLIKE] as? Int ?? 0
    }
    
    // MARK: - Fetch like user
    
    class func fetchLikeUser(_ forUserId: String, completion: @escaping(_ like: Like) -> Void) {
        
        COLLECTION_LIKES.document(forUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard snapshot?.data() != nil else { return }
            print("DEBUG: \(snapshot!.data()!)")
            let like = Like(dict: snapshot!.data()! as [String: Any])
            completion(like)
        }
    }
    
    class func fetchLikeUsers(completion: @escaping([Like]) -> Void) {
        var likes: [Like] = []

        COLLECTION_LIKES.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let like = Like(dict: dict)
                likes.append(like)
                
                if likes.count == snapshot?.documents.count {
                    completion(likes)
                }
            })
        }
    }
}
