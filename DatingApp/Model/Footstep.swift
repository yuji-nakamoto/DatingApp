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
    var date: Double!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        self.uid = dict[UID] as? String ?? ""
        self.isFootStep = dict[ISFOOTSTEP] as? Int ?? 0
        self.date = dict[DATE] as? Double ?? 0
    }
    
    // MARK: - Fetch isFootStep user
    
    class func fetchFootstepUser(_ forUserId: String, completion: @escaping(_ footStep: Footstep) -> Void) {
        
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection(ISFOOTSTEP).document(forUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if snapshot?.data() == nil {
                completion(Footstep(dict: [UID: ""]))
            }
            guard snapshot?.data() != nil else { return }
            let footStep = Footstep(dict: snapshot!.data()! as [String: Any])
            completion(footStep)
        }
    }
    
    class func fetchFootstepUsers(completion: @escaping(Footstep) -> Void) {

        Block.fetchBlockSwipe { (blockUserIDs) in
            COLLECTION_FOOTSTEP.document(User.currentUserId()).collection(ISFOOTSTEP).order(by: DATE).limit(to: 10).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription) ")
                }
                
                if snapshot?.documents == [] {
                    completion(Footstep(dict: [UID: ""]))
                }
                snapshot?.documents.forEach({ (document) in
                    let dict = document.data()
                    let footstep = Footstep(dict: dict)
                    guard blockUserIDs[footstep.uid] == nil else { return }
                    completion(footstep)
                })
            }
        }
    }
    
    // MARK: - Fetch footsteped user
    
    class func fetchFootstepedUsers(completion: @escaping(Footstep) -> Void) {
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            COLLECTION_FOOTSTEP.document(User.currentUserId()).collection(FOOTSTEPED).order(by: DATE).limit(to: 10).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription) ")
                }
                
                if snapshot?.documents == [] {
                    completion(Footstep(dict: [UID: ""]))
                }
                snapshot?.documents.forEach({ (document) in
                    let dict = document.data()
                    let footstep = Footstep(dict: dict)
                    guard blockUserIDs[footstep.uid] == nil else { return }
                    completion(footstep)
                })
            }
        }
    }
    
    // MARK: - Save
    
    class func saveIsFootstepUser(toUserId: String) {
                
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection(ISFOOTSTEP).document(toUserId).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: toUserId,
                        ISFOOTSTEP: 1,
                        DATE: date] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection(ISFOOTSTEP).document(toUserId).updateData(dict)
            } else {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection(ISFOOTSTEP).document(toUserId).setData(dict)
            }
        }
    }
    
    class func saveFootstepedUser(toUserId: String) {
                
        COLLECTION_FOOTSTEP.document(toUserId).collection(FOOTSTEPED).document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: User.currentUserId(),
                        DATE: date] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(toUserId).collection(FOOTSTEPED).document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_FOOTSTEP.document(toUserId).collection(FOOTSTEPED).document(User.currentUserId()).setData(dict)
            }
        }
    }
}
