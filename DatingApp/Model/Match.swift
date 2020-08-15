//
//  Match.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/06.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

class Match {
    
    var uid: String!
    var date: Double!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
    }
    
    // MARK: - Fetch match user
    
    class func fetchMatchUser(completion: @escaping(Match) -> Void) {
        
        Block.fetchBlock { (blockUserIDs) in
            COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: fetch match user: \(error.localizedDescription)")
                }
                if snapshot?.documents == [] {
                    completion(Match(dict: [UID: ""]))
                }
                snapshot?.documents.forEach({ (document) in
                    let dict = document.data()
                    let match = Match(dict: dict)
                    
                    guard blockUserIDs[match.uid] == nil else {
                        completion(Match(dict: [UID: ""]))
                        return
                    }
                    completion(match)
                })
            }
        }
    }
    
    // MARK: - Save
    
    class func saveMatchUser(forUser user: User) {
        
        COLLECTION_MATCH.document(User.currentUserId()).collection("isMatch").document(user.uid).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: user.uid!, DATE: date] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_MATCH.document(User.currentUserId()).collection("isMatch").document(user.uid).updateData(dict as [AnyHashable : Any])
            } else {
                COLLECTION_MATCH.document(User.currentUserId()).collection("isMatch").document(user.uid).setData(dict as [String : Any])
            }
        }
        COLLECTION_MATCH.document(user.uid).collection("isMatch").document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: User.currentUserId(), DATE: date] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_MATCH.document(user.uid).collection("isMatch").document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_MATCH.document(user.uid).collection("isMatch").document(User.currentUserId()).setData(dict)
            }
        }
    }
}
