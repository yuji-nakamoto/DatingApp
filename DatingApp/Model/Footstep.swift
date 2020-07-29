//
//  Footstep.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Footstep {
    var uid: String!
    var isFootStep: Int!
    var timestamp: Timestamp!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        self.uid = dict[UID] as? String ?? ""
        self.isFootStep = dict[ISFOOTSTEP] as? Int ?? 0
        self.timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
    }
    
    // MARK: - Fetch isFootStep user
    
    class func fetchFootstepUser(_ forUserId: String, completion: @escaping(_ footStep: Footstep) -> Void) {
        
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(forUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard snapshot?.data() != nil else { return }
//            print("DEBUG fetch step user \(snapshot?.data())")
            let footStep = Footstep(dict: snapshot!.data()! as [String: Any])
            completion(footStep)
        }
    }
    
    class func fetchFootstepUsers(completion: @escaping(Footstep) -> Void) {

        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").order(by: TIMESTAMP).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
//                print("DEBUG: fetch step document data\(document.data())")
                let dict = document.data()
                let footStep = Footstep(dict: dict)
                completion(footStep)
            })
        }
    }
    
    // MARK: - Fetch footsteped user
    
    class func fetchFootstepedUser(completion: @escaping(Footstep) -> Void) {
        
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("footsteped").order(by: TIMESTAMP).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: \(error.localizedDescription) ")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                print("DEBUG: fetch steped document data\(document.data())")
                let footStep = Footstep(dict: dict)
                completion(footStep)
            })
        }
    }
    
    // MARK: - Save
    
    class func saveIsFootstepUser(forUser user: User, isFootStep: [String: Any]) {
                
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(user.uid).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(user.uid).updateData(isFootStep)
            } else {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(user.uid).setData(isFootStep)
            }
        }
    }
    
    class func saveIsFootstepUser2(userId: String, isFootStep: [String: Any]) {
                
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(userId).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(userId).updateData(isFootStep)
            } else {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(userId).setData(isFootStep)
            }
        }
    }
    
    class func saveFootstepedUser(forUser user: User) {
                
        COLLECTION_FOOTSTEP.document(user.uid).collection("footsteped").document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let dict = [UID: User.currentUserId(),
                        TIMESTAMP: Timestamp(date: Date())] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(user.uid).collection("footsteped").document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_FOOTSTEP.document(user.uid).collection("footsteped").document(User.currentUserId()).setData(dict)
            }
        }
    }
    
    class func saveFootstepedUser2(userId: String) {
                
        COLLECTION_FOOTSTEP.document(userId).collection("footsteped").document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let dict = [UID: User.currentUserId(),
                        TIMESTAMP: Timestamp(date: Date())] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(userId).collection("footsteped").document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_FOOTSTEP.document(userId).collection("footsteped").document(User.currentUserId()).setData(dict)
            }
        }
    }
}
