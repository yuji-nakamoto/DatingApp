//
//  Notice.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Notice {
    
    var title: String!
    var time: Timestamp!
    var genre: String!
    var title2: String!
    var mainText: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        title = dict[TITLE] as? String ?? ""
        time = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        genre = dict[GENRE] as? String ?? ""
        title2 = dict[TITLE2] as? String ?? ""
        mainText = dict[MAINTEXT] as? String ?? ""
    }
    
    class func fetchNoticeList(comletion: @escaping(Notice) ->Void) {
        
        COLLECTION_NOTICE.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (documents) in
                
                let notice = Notice(dict: documents.data())
                comletion(notice)
            })
        }
    }
    
    class func fetchNotice1(comletion: @escaping(Notice) ->Void) {
        
        COLLECTION_NOTICE.document("notice1").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = Notice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice2(comletion: @escaping(Notice) ->Void) {
        
        COLLECTION_NOTICE.document("notice2").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = Notice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice3(comletion: @escaping(Notice) ->Void) {
        
        COLLECTION_NOTICE.document("notice3").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = Notice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice4(comletion: @escaping(Notice) ->Void) {
        
        COLLECTION_NOTICE.document("notice4").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = Notice(dict: dict)
            comletion(notice)
        }
    }
    
    class func fetchNotice5(comletion: @escaping(Notice) ->Void) {
        
        COLLECTION_NOTICE.document("notice5").getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch notce: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let notice = Notice(dict: dict)
            comletion(notice)
        }
    }
}
