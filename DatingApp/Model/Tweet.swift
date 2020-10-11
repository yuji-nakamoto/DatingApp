//
//  Tweet.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Tweet {
    
    var contentsImageUrl: String!
    var text: String!
    var date: Double!
    var date2: Double!
    var timestamp: Timestamp!
    var tweetId: String!
    var uid: String!
    var likeCount: Int!
    var likeCount2: Int!
    var comment: String!
    var commentId: String!
    var commentCount: Int!
    var communityId: String!
    var reply: String!
    var replyId: String!
    var isReply: Bool!
    var replyUserId: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        contentsImageUrl = dict[CONTENTSIMAGEURL] as? String ?? ""
        text = dict[TEXT] as? String ?? ""
        tweetId = dict[TWEETID] as? String ?? ""
        date = dict[DATE] as? Double ?? 0
        date2 = dict[DATE2] as? Double ?? 0
        timestamp = dict[TIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        uid = dict[UID] as? String ?? ""
        likeCount = dict[LIKECOUNT] as? Int ?? 0
        likeCount2 = dict[LIKECOUNT2] as? Int ?? 0
        comment = dict[COMMENT] as? String ?? ""
        commentCount = dict[COMMENTCOUNT] as? Int ?? 0
        communityId = dict[COMMUNITYID] as? String ?? ""
        commentId = dict[COMMENTID] as? String ?? ""
        reply = dict[REPLY] as? String ?? ""
        replyId = dict[REPLYID] as? String ?? ""
        isReply = dict[ISREPLY] as? Bool ?? false
        replyUserId = dict[REPLYUSERID] as? String ?? ""
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
    
    class func fetchTweet(tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet: \(error.localizedDescription)")
            }
            if snapshot?.data() == nil {
                completion(Tweet(dict: [TWEETID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let tweet = Tweet(dict: dict)
            completion(tweet)
        }
    }
    
    class func fetchTweetComments(tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).collection("comments").order(by: DATE, descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet comment: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(Tweet(dict: [UID: ""]))
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let tweetComment = Tweet(dict: dict)
                completion(tweetComment)
            })
        }
    }
    
    class func fetchTweetComment(commentId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_TWEET_COMMENT.document(commentId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet comment: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let tweet = Tweet(dict: dict)
            completion(tweet)
        }
    }
    
    class func fetchTweetCommentCount(communityId: String, tweetId: String, completion: @escaping(Tweet) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch tweet comment: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let tweetComment = Tweet(dict: dict)
            completion(tweetComment)
        }
    }
    
    class func fetchCommentReplys(completion: @escaping(Tweet) ->Void) {
        
        COLLECTION_COMMENT_REPLY.document(User.currentUserId()).collection("comment_reply").order(by: DATE).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch comment reply: \(error.localizedDescription)")
            }
            if snapshot?.documents == [] {
                completion(Tweet(dict: [UID: ""]))
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let commentReply = Tweet(dict: dict)
                completion(commentReply)
            })
        }
    }
    
    class func checkIsLikeTweet(communityId: String, tweetId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func checkIsLike1Comment(tweetId: String, commentId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike1").document("isLike1").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func checkIsLike2Comment(tweetId: String, commentId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike2").document("isLike2").getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
        
    class func saveTweetComment(tweetId: String, commentId: String, withValue: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).setData(withValue)
        
        COLLECTION_TWEET_COMMENT.document(commentId).setData(withValue)
    }
    
    class func saveCommentReply(commentId: String, userId: String, withValue: [String: Any]) {
        COLLECTION_COMMENT_REPLY.document(userId).collection("comment_reply").document(commentId).setData(withValue)
    }
    
    class func saveTweet(communityId: String, tweetId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).setData(withValue)
        
        COLLECTION_TWEET.document(tweetId).setData(withValue)
    }
    
    class func updateIsLikeTweet(communityId: String, tweetId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).updateData(value1)
        
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").updateData(value2)
            } else {
                COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).collection("isLike").document("isLike").setData(value2)
            }
        }
    }
    
    class func updateIsLike1Comment(tweetId: String, commentId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).updateData(value1)
        
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike1").document("isLike1").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike1").document("isLike1").updateData(value2)
            } else {
                COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike1").document("isLike1").setData(value2)
            }
        }
    }
    
    class func updateIsLike2Comment(tweetId: String, commentId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).updateData(value1)
        
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike2").document("isLike2").getDocument { (snapshot, error) in
            
            if snapshot?.exists == true {
                COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike2").document("isLike2").updateData(value2)
            } else {
                COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).collection("isLike2").document("isLike2").setData(value2)
            }
        }
    }
    
    class func updateCommentCount(communityId: String, tweetId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).updateData(withValue)
    }
    
    class func updateTweetComment(tweetId: String, commentId: String, withValue: [String: Any]) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).updateData(withValue)
    }
    
    class func deleteTweet(communityId: String, tweetId: String) {
        COLLECTION_COMMUNITY.document(communityId).collection("tweets").document(tweetId).delete()
        
        COLLECTION_TWEET.document(tweetId).delete()
    }
    
    class func deleteComment(tweetId: String, commentId: String) {
        COLLECTION_TWEET.document(tweetId).collection("comments").document(commentId).delete()
        
        COLLECTION_TWEET_COMMENT.document(commentId).delete()
    }
}
