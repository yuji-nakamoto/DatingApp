//
//  TweetTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class TweetTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var tweetVC: TweetTableViewController?
    var tweetCommentVC: TweetCommentViewController?
    var user = User()
    var tweet = Tweet()
    var community = Community()
    
    // MARK: - Cell
    
    func configureCell(_ tweet: Tweet, _ user: User) {
        
        nameLabel.text = user.username
        if user.profileImageUrl1 != nil {
            profileImageVIew.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        }
        
        if tweet.contentsImageUrl == nil { return }
        contentsImageView.sd_setImage(with: URL(string: tweet.contentsImageUrl), completed: nil)

        if UserDefaults.standard.object(forKey: RESIZE) != nil {
            if tweet.contentsImageUrl == "" {
                heightConstraint.constant = 0
                bottomConstraint.constant = 0
            } else {
                heightConstraint.constant = 200
                bottomConstraint.constant = 15
            }
        } else {
            if tweet.contentsImageUrl == "" {
                heightConstraint.constant = 0
                bottomConstraint.constant = 0
            } else {
                heightConstraint.constant = 300
                bottomConstraint.constant = 15
            }
        }
        
        tweetLabel.text = tweet.text
        
        if tweet.date != nil {
            let date = Date(timeIntervalSince1970: tweet.date)
            let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            timeLabel.text = dateString
        }
        
        guard likeButton != nil else { return }
        if tweet.likeCount == nil { return }
        likeCountLabel.text = String(tweet.likeCount)
        
        if tweet.commentCount == nil { return }
        commentCountLabel.text = String(tweet.commentCount)
        
        if tweet.uid == User.currentUserId() {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    func configureLikeCount() {
        
        Tweet.checkIsLikeTweet(communityId: community.communityId, tweetId: tweet.tweetId) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                self.likeButton.setImage(UIImage(named: "heart2"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "heart3"), for: .normal)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        Tweet.checkIsLikeTweet(communityId: self.community.communityId, tweetId: tweet.tweetId) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                
                self.likeButton.setImage(UIImage(named: "heart3"), for: .normal)
                self.likeCountLabel.text = String(self.tweet.likeCount + 1)
                Tweet.updateIsLikeTweet(communityId: self.community.communityId, tweetId: self.tweet.tweetId,
                                  value1: [LIKECOUNT: self.tweet.likeCount + 1],
                                  value2: [User.currentUserId(): true])
            }
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        
        if let uid = tweet.tweetId {
            UserDefaults.standard.set(true, forKey: RESIZE)
            tweetVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "投稿を削除しますか？", preferredStyle: .alert)
        let delete: UIAlertAction = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in
            UserDefaults.standard.set(true, forKey: REFRESH)
            Tweet.deleteTweet(communityId: self.tweetVC!.communityId, tweetId: self.tweet.tweetId)
            self.tweetVC?.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        tweetVC?.present(alert,animated: true,completion: nil)
    }
    
    @objc func tapProfileImageView() {
        
        if let uid = user.uid {
            if uid == User.currentUserId() { return }
            tweetVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
            tweetCommentVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
        }
    }
    
    @objc func tapContentsImageView() {
        
        if let uid = tweet.tweetId {
            UserDefaults.standard.set(true, forKey: RESIZE)
            tweetVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
    }
    
    @objc func tapTweetLabel() {
        
        if let uid = tweet.tweetId {
            UserDefaults.standard.set(true, forKey: RESIZE)
            tweetVC?.performSegue(withIdentifier: "TweetCommentVC", sender: uid)
        }
    }
    
    // MARK: - Helper
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapContentsImageView))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapTweetLabel))
        profileImageVIew.addGestureRecognizer(tap1)
        contentsImageView.addGestureRecognizer(tap2)
        tweetLabel.addGestureRecognizer(tap3)
        profileImageVIew.layer.cornerRadius = 60 / 2
        contentsImageView.layer.cornerRadius = 15
        
        backView.layer.cornerRadius = 10
        backView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowRadius = 4
        timeLabel.text = ""
        tweetLabel.text = ""
        nameLabel.text = ""
        profileImageVIew.image = nil
        contentsImageView.image = nil
    }
}
