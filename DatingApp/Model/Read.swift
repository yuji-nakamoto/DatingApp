//
//  Read.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/08.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

class Read {
    
    var readed: Int!
    
    init(dict: [String: Any]) {
        readed = dict[ISREAD] as? Int ?? 0
    }
    
    class func fetchRead(toUserId: String, completion: @escaping(_ read: Read) -> Void) {
        
        COLLECTION_MESSAGE.document(toUserId).collection(User.currentUserId()).document(User.currentUserId()).addSnapshotListener { (snapshot, error) in
             
            if let error = error {
                print("Error fetch read: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let read = Read(dict: dict)
            completion(read)
        }
    }
    
//    class func updateRead(_ toUserId: String) {
//        
//        let dict = [ISREAD: 1]
//        COLLECTION_MESSAGE.document(User.currentUserId()).collection(toUserId).document(toUserId).updateData(dict)
//    }
}
