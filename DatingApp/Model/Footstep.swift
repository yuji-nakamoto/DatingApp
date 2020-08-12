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

        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").order(by: DATE).getDocuments { (snapshot, error) in
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
        
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("footsteped").order(by: DATE).getDocuments { (snapshot, error) in
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
    
    class func saveIsFootstepUser(toUserId: String) {
                
        COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(toUserId).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: toUserId,
                        ISFOOTSTEP: 1,
                        DATE: date] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(toUserId).updateData(dict)
            } else {
                COLLECTION_FOOTSTEP.document(User.currentUserId()).collection("isFootstep").document(toUserId).setData(dict)
            }
        }
    }
    
    class func saveFootstepedUser(toUserId: String) {
                
        COLLECTION_FOOTSTEP.document(toUserId).collection("footsteped").document(User.currentUserId()).getDocument { (snapshot, error) in
            
            let date: Double = Date().timeIntervalSince1970
            let dict = [UID: User.currentUserId(),
                        DATE: date] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_FOOTSTEP.document(toUserId).collection("footsteped").document(User.currentUserId()).updateData(dict)
            } else {
                COLLECTION_FOOTSTEP.document(toUserId).collection("footsteped").document(User.currentUserId()).setData(dict)
            }
        }
    }
    
}
