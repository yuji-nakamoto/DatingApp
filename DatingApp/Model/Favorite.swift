//
//  Favorite.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/04.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Favorite {
    
    var uid: String!
    var timestamp: Timestamp!
    var isFavorite: Bool!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        isFavorite = dict[ISFAVORITE] as? Bool ?? false
    }
    
    class func fetchIsFavariteUser(_ userId: String, completion: @escaping(Favorite) -> Void) {
        
        COLLECTION_FAVORITE.document(User.currentUserId()).collection("favorite").document(userId).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let dict = snapshot?.data() else { return }
            let favorite = Favorite(dict: dict)
            completion(favorite)
        }
    }
    
    class func fetchFavoriteUsers(completion: @escaping(Favorite) -> Void) {
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            COLLECTION_FAVORITE.document(User.currentUserId()).collection("favorite").order(by: TIMESTAMP).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription) ")
                }
                
                if snapshot?.documents == [] {
                    completion(Favorite(dict: [UID: ""]))
                }
                snapshot?.documents.forEach({ (document) in
                    let dict = document.data()
                    let favorite = Favorite(dict: dict)
                    guard blockUserIDs[favorite.uid] == nil else { return }
                    completion(favorite)
                })
            }
        }
    }
    
    class func saveFavorite(forUser user: User, dict: [String: Any]) {
        
        COLLECTION_FAVORITE.document(User.currentUserId()).collection("favorite").document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FAVORITE.document(User.currentUserId()).collection("favorite").document(user.uid).updateData(dict)
            } else {
                COLLECTION_FAVORITE.document(User.currentUserId()).collection("favorite").document(user.uid).setData(dict)
            }
        }
    }
    
    class func deleteFavorite(userId: String) {
        COLLECTION_FAVORITE.document(User.currentUserId()).collection("favorite").document(userId).delete()
    }
}
