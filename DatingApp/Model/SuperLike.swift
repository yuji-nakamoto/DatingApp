//
//  SuperLike.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

class SuperLike {
    var name: String!
    var age: String!
    var residence: String!
    var profileImageUrl: String!
    var uid: String!
    var isSuperLike: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        self.name = dict[USERNAME] as? String ?? ""
        self.profileImageUrl = dict[PROFILEIMAGEURL1] as? String ?? ""
        self.uid = dict[UID] as? String ?? ""
        self.age = dict[AGE] as? String ?? ""
        self.residence = dict[RESIDENCE] as? String ?? ""
        self.isSuperLike = dict[ISSUPERLIKE] as? Int ?? 0
    }
    
    // MARK: - Fetch like user
    
    class func fetchSuperLikeUser(_ forUserId: String, completion: @escaping(_ superLike: SuperLike) -> Void) {
        
        COLLECTION_SUPERLIKES.document(forUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard snapshot?.data() != nil else { return }
            let superLike = SuperLike(dict: snapshot!.data()! as [String: Any])
            completion(superLike)
        }
    }
    
    class func fetchSuperLikeUsers(completion: @escaping([SuperLike]) -> Void) {
        var superLikes: [SuperLike] = []

        COLLECTION_SUPERLIKES.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let superLike = SuperLike(dict: dict)
                superLikes.append(superLike)
                
                if superLikes.count == snapshot?.documents.count {
                    completion(superLikes)
                }
            })
        }
    }
    
    // MARK: - Save
    
    class func saveSuperLikes(forUser user: User, isSuperLike: [String: Any]) {
                
        COLLECTION_SUPERLIKES.document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_SUPERLIKES.document(user.uid).updateData(isSuperLike)
            } else {
                COLLECTION_SUPERLIKES.document(user.uid).setData(isSuperLike)
            }
        }
    }
}
