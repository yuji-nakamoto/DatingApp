//
//  Message.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/01.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    var from: String!
    var to: String!
    var messageText: String!
    var timestamp: Timestamp!
    var date: Double!
    var isRead: Bool!
    var messageId: String!
    var isFromCurrentUser: Bool!
    
    var chatPartnerId: String {
        return isFromCurrentUser ? to : from
    }
    
    init() {
    }
    
    init(dict: [String: Any]) {
        from = dict[FROM] as? String ?? ""
        to = dict[TO] as? String ?? ""
        messageText = dict[MESSAGETEXT] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        date = dict[DATE] as? Double ?? 0
        isRead = dict[ISREAD] as? Bool ?? false
        messageId = dict[MESSAGEID] as? String ?? ""
        
        isFromCurrentUser = from == User.currentUserId()
    }
    
    class func fetchMessage(toUserId: String, completion: @escaping(Message) -> Void) {
    
        COLLECTION_MESSAGE.document(User.currentUserId()).collection(toUserId).order(by: TIMESTAMP).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print("Error fetch message: \(error.localizedDescription)")
            }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dict = change.document.data()
                    let message = Message(dict: dict)
                    completion(message)
                }
            })
        }
    }
    
    class func fetchMessage2(toUserId: String, completion: @escaping(Message) -> Void) {
    
        COLLECTION_MESSAGE.document(User.currentUserId()).collection(toUserId).order(by: TIMESTAMP).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error fetch message: \(error.localizedDescription)")
            }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dict = change.document.data()
                    let message = Message(dict: dict)
                    completion(message)
                }
            })
        }
    }
    
    class func fetchIsRead(toUserId: String, completion: @escaping(Message) -> Void) {
    
        COLLECTION_MESSAGE.document(User.currentUserId()).collection(toUserId).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error fetch message: \(error.localizedDescription)")
            }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dict = change.document.data()
                    let message = Message(dict: dict)
                    completion(message)
                }
            })
        }
    }
    
    
    class func saveMessage(to user: User, messageId: String, withValue: [String: Any]) {
        
        COLLECTION_MESSAGE.document(User.currentUserId()).collection(user.uid).document(messageId).setData(withValue) { (error) in
            if let error = error {
                print("Error save message: \(error.localizedDescription)")
            }
            COLLECTION_MESSAGE.document(user.uid).collection(User.currentUserId()).document(messageId).setData(withValue)
        }
        
        COLLECTION_INBOX.document(User.currentUserId()).collection("resent-messages").document(user.uid).setData(withValue)
        COLLECTION_INBOX.document(user.uid).collection("resent-messages").document(User.currentUserId()).setData(withValue)
    }
    
    class private func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func fetchInbox(completion: @escaping([Inbox]) -> Void) {
        var inboxArray = [Inbox]()
        Block.fetchBlockSwipe { (blockUserIDs) in
            COLLECTION_INBOX.document(User.currentUserId()).collection("resent-messages").order(by: USEDITEM5, descending: true).order(by: TIMESTAMP).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetch conversation: \(error.localizedDescription)")
                }
                if snapshot?.documents == [] {
                    completion(inboxArray)
                }
                snapshot?.documentChanges.forEach({ (change) in
                    let dict = change.document.data()
                    let message = Message(dict: dict)
                    
                    self.fetchUser(withUid: message.chatPartnerId) { (user) in
                        let inbox = Inbox(user: user, message: message)
                        guard blockUserIDs[user.uid] == nil else { return }
                        inboxArray.append(inbox)
                        completion(inboxArray)
                    }
                    completion(inboxArray)
                })
            }
        }
    }
}

struct Inbox {
    let user: User
    let message: Message
}
