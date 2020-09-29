//
//  Tweet.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

class Tweet {
    
    var contentsImageUrl: String!
    var text: String!
    var date: Double!
    var tweetId: String!
    var uid: String!
    var likeCount: Int!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        contentsImageUrl = dict[CONTENTSIMAGEURL] as? String ?? ""
        text = dict[TEXT] as? String ?? ""
        tweetId = dict[TWEETID] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
        uid = dict[UID] as? String ?? ""
        likeCount = dict[LIKECOUNT] as? Int ?? 0
    }
    
    class func fetchTweet(communityId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").order(by: DATE, descending: true).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error fetch tweet: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(Tweet(dict: [UID: ""]))
            }
            snapshot?.documents.forEach({ (document) in
                let dict = document.data()
                let tweet = Tweet(dict: dict)
                completion(tweet)
            })
        }
    }
    
    class func checkLikeTweet(communityId: String, toUserId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(toUserId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func saveTweet(communityId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(User.currentUserId()).setData(withValue)
    }
    
    class func updateTweet(communityId: String, toUserId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(toUserId).updateData(value1)
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(toUserId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(toUserId).collection("isLike").document("isLike").updateData(value2)
            } else {
                COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(toUserId).collection("isLike").document("isLike").setData(value2)
            }
        }
    }
}
