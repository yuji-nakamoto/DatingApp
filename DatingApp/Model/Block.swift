//
//  Block.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/12.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Block {
    
    var isBlock: Int!
    var uid: String!
    var timestamp: Timestamp!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        isBlock = dict[ISBLOCK] as? Int ?? 0
        uid = dict[UID] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
    }
    
    class func fetchBlockUsers(completion: @escaping(Block) -> Void) {
        
        COLLECTION_BLOCK.document(User.currentUserId()).collection(ISBLOCK).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch block user: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let block = Block(dict: document.data())
                completion(block)
            })
        }
    }
    
    class func fetchBlockUser(toUserId: String, compltion: @escaping(Block) -> Void) {
        
        COLLECTION_BLOCK.document(User.currentUserId()).collection(ISBLOCK).document(toUserId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch block user: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let block = Block(dict: dict)
            compltion(block)
        }
    }
    
    class func fetchBlockSwipe(completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_BLOCK.document(User.currentUserId()).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func saveBlock(toUserId: String) {
        
        COLLECTION_BLOCK.document(User.currentUserId()).getDocument { (snapshot, error) in
            let data = [toUserId: true]
            let data2 = [UID: toUserId, ISBLOCK: 1, TIMESTAMP: Timestamp(date: Date())] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_BLOCK.document(User.currentUserId()).updateData(data)
                COLLECTION_BLOCK.document(User.currentUserId()).collection(ISBLOCK).document(toUserId).setData(data2)
            } else {
                COLLECTION_BLOCK.document(User.currentUserId()).setData(data)
                COLLECTION_BLOCK.document(User.currentUserId()).collection(ISBLOCK).document(toUserId).setData(data2)
            }
        }
        
        COLLECTION_BLOCK.document(toUserId).getDocument { (snapshot, error) in
            let data3 = [User.currentUserId(): true]
            let data4 = [UID: User.currentUserId(), ISBLOCK: 0, TIMESTAMP: Timestamp(date: Date())] as [String : Any]
            
            if snapshot?.exists == true {
                COLLECTION_BLOCK.document(toUserId).updateData(data3)
                COLLECTION_BLOCK.document(toUserId).collection(ISBLOCK).document(User.currentUserId()).setData(data4)
            } else {
                COLLECTION_BLOCK.document(toUserId).setData(data3)
                COLLECTION_BLOCK.document(toUserId).collection(ISBLOCK).document(User.currentUserId()).setData(data4)
            }
        }
    }
    
    class func deleteBlock(toUserId: String) {
        let data = [toUserId: FieldValue.delete()]
        let data2 = [User.currentUserId(): FieldValue.delete()]

        COLLECTION_BLOCK.document(User.currentUserId()).collection(ISBLOCK).document(toUserId).delete()
        COLLECTION_BLOCK.document(toUserId).collection(ISBLOCK).document(User.currentUserId()).delete()
        COLLECTION_BLOCK.document(User.currentUserId()).updateData(data)
        COLLECTION_BLOCK.document(toUserId).updateData(data2)
    }
}
