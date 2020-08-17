//
//  Comment.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/17.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

class Comment {
    
    var uid: String!
    var text: String!
    var date: Double!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        text = dict[TEXT] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
    }
    
    class func saveComment(comment: String) {
        
        let date: Double = Date().timeIntervalSince1970
        let dict = [TEXT: comment,
                    UID: User.currentUserId(),
                    DATE: date] as [String : Any]
        COLLECTION_COMMENT.document(User.currentUserId()).setData(dict)
    }
    
    class func fetchComment(toUserId: String, completion: @escaping(Comment) -> Void) {
        
        COLLECTION_COMMENT.document(toUserId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch comment: \(error.localizedDescription)")
            }
            if snapshot?.data() == nil {
                completion(Comment(dict: [UID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let comment = Comment(dict: dict)
            completion(comment)
        }
    }
}
