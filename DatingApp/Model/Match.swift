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
        
        Block.fetchBlockSwipe { (blockUserIDs) in
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
            if snapshot?.data() == nil {
                completion(Match(dict: [ISMATCH: 0]))
            }
            guard let data = snapshot?.data() else { return }
            let match = Match(dict: data)
            completion(match)
        }
    }
    
    class func fetchMatch(completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_MATCH.document(User.currentUserId()).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    // MARK: - Save
    
    class func saveMatchUser(forUser user: User) {
        
        COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).document(user.uid).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let data = [user.uid: true]
            let dict = [UID: user.uid!,
                        DATE: date,
                        ISMATCH: 1] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).document(user.uid).updateData(dict as [AnyHashable : Any])
                COLLECTION_MATCH.document(User.currentUserId()).updateData(data)
            } else {
                COLLECTION_MATCH.document(User.currentUserId()).collection(ISMATCH).document(user.uid).setData(dict as [String : Any])
                COLLECTION_MATCH.document(User.currentUserId()).setData(data as! [String : Any])
            }
        }
        COLLECTION_MATCH.document(user.uid).collection(ISMATCH).document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let data = [User.currentUserId(): true]
            let dict = [UID: User.currentUserId(),
                        DATE: date,
                        ISMATCH: 1] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_MATCH.document(user.uid).collection(ISMATCH).document(User.currentUserId()).updateData(dict)
                COLLECTION_MATCH.document(user.uid).updateData(data)
            } else {
                COLLECTION_MATCH.document(user.uid).collection(ISMATCH).document(User.currentUserId()).setData(dict)
                COLLECTION_MATCH.document(user.uid).setData(data as [String : Any])
            }
        }
    }
}
