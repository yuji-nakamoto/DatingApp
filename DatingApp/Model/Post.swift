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
    var date: Double!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        
        uid = dict[UID] as? String ?? ""
        caption = dict[CAPTION] as? String ?? ""
        postId = dict[POSTID] as? String ?? ""
        genre = dict[GENRE] as? String ?? ""
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        date = dict[DATE] as? Double ?? 0
    }
    
    class func fetchPosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "男性")
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
            
        } else {
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .order(by: TIMESTAMP)
                    .whereField(GENDER, isEqualTo: "女性")
                
                postRef.getDocuments { (snapshot, error) in
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
                
                postRef.getDocuments { (snapshot, error) in
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
    }
    
    class func fetchGenreLoverPosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(GENRE, isEqualTo: "恋人募集")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .whereField(GENRE, isEqualTo: "恋人募集")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
            
        } else {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "恋人募集")
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "恋人募集")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
    }
    
    class func fetchGenreFriendPosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(GENRE, isEqualTo: "友達募集")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .whereField(GENRE, isEqualTo: "友達募集")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
            
        } else {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "友達募集")
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "友達募集")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
    }
    
    class func fetchGenreMailFriendPosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(GENRE, isEqualTo: "メル友募集")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .whereField(GENRE, isEqualTo: "メル友募集")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
            
        } else {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "メル友募集")
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "メル友募集")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
    }
    
    class func fetchGenrePlayPosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(GENRE, isEqualTo: "遊びたい")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .whereField(GENRE, isEqualTo: "遊びたい")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
            
        } else {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "遊びたい")
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "遊びたい")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
    }
    
    class func fetchGenreFreePosts(_ residenceSearch: String, completion: @escaping(_ post: Post) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(GENRE, isEqualTo: "ヒマしてる")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "男性")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .whereField(GENRE, isEqualTo: "ヒマしてる")
                    .order(by: TIMESTAMP)
                
                
                postRef.getDocuments { (snapshot, error) in
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
            
        } else {
            
            if UserDefaults.standard.object(forKey: ALL) != nil {
                let postRef = COLLECTION_POSTS
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "ヒマしてる")
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
                    .whereField(GENDER, isEqualTo: "女性")
                    .whereField(GENRE, isEqualTo: "ヒマしてる")
                    .whereField(RESIDENCE, isEqualTo: residenceSearch)
                    .order(by: TIMESTAMP)
                
                postRef.getDocuments { (snapshot, error) in
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
    }
    
    class func fetchMyPost(completion: @escaping(_ post: Post) -> Void) {
        
        COLLECTION_POSTS.document(User.currentUserId()).getDocument { (snapshot, error) in
            if let error = error {
                print("ERROR fetch my post: \(error.localizedDescription)")
            }
            if snapshot?.data() == nil {
                completion(Post(dict: [UID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let myPost = Post(dict: dict)
            completion(myPost)
        }
    }
    
    class func savePost(withValue: [String: Any]) {
        
        COLLECTION_POSTS.document(User.currentUserId()).setData(withValue) { (error) in
            if let error = error {
                print("Error save post: \(error.localizedDescription)")
            }
        }
    }
}
