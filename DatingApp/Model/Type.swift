//
//  Type.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Type {

    var uid: String!
    var isType: Int!
    var timestamp: Timestamp!

    init() {
    }
    
    init(dict: [String: Any]) {

        self.uid = dict[UID] as? String ?? ""
        self.isType = dict[ISTYPE] as? Int ?? 0
        self.timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
    }
    
    // MARK: - Fetch isLike user
    
    class func fetchTypeUser(_ forUserId: String, completion: @escaping(_ type: Type) -> Void) {
        
        COLLECTION_TYPE.document(User.currentUserId()).collection("isType").document(forUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard snapshot?.data() != nil else { return }
            let type = Type(dict: snapshot!.data()! as [String: Any])
            completion(type)
        }
    }
    
    class func fetchTypeUsers(completion: @escaping(Type) -> Void) {
        
        COLLECTION_TYPE.document(User.currentUserId()).collection("isType").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
//                print("DEBUG: fetchTypeUsers document data\(document.data())")
                let dict = document.data()
                let type = Type(dict: dict)
                completion(type)
            })
        }
    }
    
    // MARK: - Fetch liked user
    
    class func fetchTypedUser(completion: @escaping(Type) -> Void) {
        
        COLLECTION_TYPE.document(User.currentUserId()).collection("typed").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let type = Type(dict: dict)
                completion(type)
            })
        }
    }
    
    // MARK: - Save
    
    class func saveIsTypeUser(forUser user: User, isType: [String: Any]) {
        
        COLLECTION_TYPE.document(User.currentUserId()).collection("isType").document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_TYPE.document(User.currentUserId()).collection("isType").document(user.uid).updateData(isType)
            } else {
                COLLECTION_TYPE.document(User.currentUserId()).collection("isType").document(user.uid).setData(isType)
            }
        }
    }
    
    class func saveTypedUser(forUser user: User) {
        
        COLLECTION_TYPE.document(user.uid).collection("typed").document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let dict = [UID: User.currentUserId()]
            
            if snapshot?.exists == true {
                COLLECTION_TYPE.document(user.uid).collection("typed").document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_TYPE.document(user.uid).collection("typed").document(User.currentUserId()).setData(dict)
            }
        }
    }
    
}
