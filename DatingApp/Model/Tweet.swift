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
    var comment: String!
    var commentId: String!
    var commentCount: Int!
    var communityId: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        contentsImageUrl = dict[CONTENTSIMAGEURL] as? String ?? ""
        text = dict[TEXT] as? String ?? ""
        tweetId = dict[TWEETID] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
        uid = dict[UID] as? String ?? ""
        likeCount = dict[LIKECOUNT] as? Int ?? 0
        comment = dict[COMMENT] as? String ?? ""
        commentCount = dict[COMMENTCOUNT] as? Int ?? 0
        communityId = dict[COMMUNITYID] as? String ?? ""
        commentId = dict[COMMENTID] as? String ?? ""
    }
    
    class func fetchTweets(communityId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").order(by: DATE, descending: true).getDocuments { (snapshot, error) in
            
            if let error = error {
                print("Error fetch tweets: \(error.localizedDescription)")
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
    
    class func fetchTweet(communityId: String, tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let tweet = Tweet(dict: dict)
            completion(tweet)
        }
    }
    
    class func fetchTweetComment(communityId: String, tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("comments").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet comment: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let tweetComment = Tweet(dict: dict)
                completion(tweetComment)
            })
        }
    }
    
    class func checkLikeTweet(communityId: String, tweetId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func fetchCommunityId(tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).getDocument { (snapshot, error) in
            guard let dict = snapshot?.data() else { return }
            let tweet = Tweet(dict: dict)
            completion(tweet)
        }
    }
    
    class func saveTweetComment(communityId: String, tweetId: String, commentId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("comments").document(commentId).setData(withValue)
    }
    
    class func saveTweetCommunityId(tweetId: String, withValue: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).setData(withValue)
    }
    
    class func saveTweet(communityId: String, tweetId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).setData(withValue)
    }
    
    class func updateTweet(communityId: String, tweetId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).updateData(value1)
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").updateData(value2)
            } else {
                COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").setData(value2)
            }
        }
    }
    
    class func updateCommentCount(communityId: String, tweetId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).updateData(withValue)
    }
    
    class func deleteTweet(communityId: String, tweetId: String) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).delete()
    }
    
    class func deleteComment(communityId: String, tweetId: String, commentId: String) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("comments").document(commentId).delete()
    }
}
