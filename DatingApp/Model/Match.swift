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
    var isMatch: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
        isMatch = dict[ISMATCH] as? Int ?? 0
    }
    
    // MARK: - Fetch match user
    
    class func fetchMatchUsers(completion: @escaping(Match) -> Void) {
        
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
    
    class func fetchMatchUser(toUserId: String, completion: @escaping(Match) -> Void) {
        
        COLLECTION_MATCH.document(toUserId).collection(ISMATCH).document(User.currentUserId()).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch match: \(error.localizedDescription)")
            }
            guard let data = snapshot?.data() else { return }
            let match = Match(dict: data)
            completion(match)
        }
    }
    
    // MARK: - Save
    
    class func saveMatchUser(forUser user: User) {
        
        COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).document(user.uid).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: user.uid!,
                        DATE: date,
                        ISMATCH: 1] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).document(user.uid).updateData(dict as [AnyHashable : Any])
            } else {
                COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).document(user.uid).setData(dict as [String : Any])
            }
        }
        COLLECTION_MATCH.document(user.uid).collection(ISMATCH).document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: User.currentUserId(),
                        DATE: date,
                        ISMATCH: 1] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_MATCH.document(user.uid).collection(ISMATCH).document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_MATCH.document(user.uid).collection(ISMATCH).document(User.currentUserId()).setData(dict)
            }
        }
    }
}
