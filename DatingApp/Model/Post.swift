//
//  Post.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    var caption: String!
    var uid: String!
    var postId: String!
    var genre: String!
    var timestamp: Timestamp!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        
        uid = dict[UID] as? String ?? ""
        caption = dict[CAPTION] as? String ?? ""
        postId = dict[POSTID] as? String ?? ""
        genre = dict[GENRE] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
    }
    
//    class func fetchPost(completion: @escaping(_ post: Post) -> Void) {
//
//        COLLECTION_POSTS.getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error fetch post: \(error.localizedDescription)")
//            }
//            snapshot?.documents.forEach({ (document) in
//                let dict = document.data()
//                let post = Post(dict: dict)
//                completion(post)
//            })
//        }
//    }
    
    class func fetchPosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            let postRef = COLLECTION_POSTS
                .whereField(GENDER, isEqualTo: "男性")
                .whereField(RESIDENCE, isEqualTo: residenceSearch)
                .order(by: TIMESTAMP)

            
            postRef.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetch posts: \(error.localizedDescription)")
                }
                snapshot?.documentChanges.forEach({ (change) in
                    let dict = change.document.data()
                    let post = Post(dict: dict)
                    guard post.uid != User.currentUserId() else { return }
                    completion(post)
                })
            }
        } else {
            let postRef = COLLECTION_POSTS
                .order(by: TIMESTAMP)
                .whereField(GENDER, isEqualTo: "女性")
                .whereField(RESIDENCE, isEqualTo: residenceSearch)
            
            postRef.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetch posts: \(error.localizedDescription)")
                }
                snapshot?.documentChanges.forEach({ (change) in
                    let dict = change.document.data()
                    let post = Post(dict: dict)
                    guard post.uid != User.currentUserId() else { return }
                    completion(post)
                })
            }
        }
    }
    
    class func fetchMyPost(comletion: @escaping(_ post: Post) -> Void) {
        
        COLLECTION_MYPOSTS.document(User.currentUserId()).collection("posts").order(by: TIMESTAMP).getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR fetch my post: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let myPost = Post(dict: dict)
                comletion(myPost)
            })
        }
    }
    
    class func fetchFeed(matchedUserId: String, comletion: @escaping(_ post: Post) -> Void) {
        
        COLLECTION_FEED.document(matchedUserId).collection(User.currentUserId()).order(by: TIMESTAMP).getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR fetch feed: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (document) in
//                print(snapshot?.documents)

                let dict = document.data()
                let feed = Post(dict: dict)
                comletion(feed)
            })
        }
    }
    
    class func savePost(_ forPostId: String, withValue: [String: Any]) {
        
        COLLECTION_POSTS.document(forPostId).setData(withValue) { (error) in
            if let error = error {
                print("Error save post: \(error.localizedDescription)")
            }
        }
    }
    
    class func saveFeed(_ forPostId: String, toUserId: String, withValue: [String: Any]) {
        print(toUserId)
        COLLECTION_FEED.document(User.currentUserId()).collection(toUserId).document(forPostId).setData(withValue) { (error) in
            if let error = error {
                print("Error save feed: \(error.localizedDescription)")
            }
        }
    }
    
    class func saveMyPost(_ forPostId: String, withValue: [String: Any]) {
        
        COLLECTION_MYPOSTS.document(User.currentUserId()).collection("posts").document(forPostId).getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_MYPOSTS.document(User.currentUserId()).collection("posts").document(forPostId).updateData(withValue)
            } else {
                COLLECTION_MYPOSTS.document(User.currentUserId()).collection("posts").document(forPostId).setData(withValue)
            }
        }
    }
}
