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
    
    var tweetVC: TweetTableViewController?
    var user = User()
    var tweet = Tweet()
    var community = Community()
    
    func configureCell(_ tweet: Tweet) {
        
        tweetLabel.text = tweet.text
        if tweet.contentsImageUrl == "" {
            heightConstraint.constant = 0
            bottomConstraint.constant = 0
        }
        contentsImageView.sd_setImage(with: URL(string: tweet.contentsImageUrl), completed: nil)
        likeCountLabel.text = String(self.tweet.likeCount)
                
        let date = Date(timeIntervalSince1970: tweet.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        timeLabel.text = dateString
    }
    
    func configureUser(_ user: User) {
        nameLabel.text = user.username
        profileImageVIew.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
    }
    
    func configureLikeCount() {
        
        Tweet.checkLikeTweet(communityId: community.communityId, toUserId: user.uid) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                self.likeButton.setImage(UIImage(named: "heart2"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "heart3"), for: .normal)
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        Tweet.checkLikeTweet(communityId: self.community.communityId, toUserId: self.user.uid) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                
                UserDefaults.standard.set(true, forKey: "likeButtonOn")
                self.likeButton.setImage(UIImage(named: "heart3"), for: .normal)
                self.likeCountLabel.text = String(self.tweet.likeCount + 1)
                Tweet.updateTweet(communityId: self.community.communityId, toUserId: self.user.uid,
                                  value1: [LIKECOUNT: self.tweet.likeCount + 1],
                                  value2: [User.currentUserId(): true])
                self.tweetVC?.viewWillAppear(true)
                
            } else {
                
                UserDefaults.standard.set(true, forKey: "likeButtonOn")
                self.likeButton.setImage(UIImage(named: "heart2"), for: .normal)
                self.likeCountLabel.text = String(self.tweet.likeCount - 1)
                Tweet.updateTweet(communityId: self.community.communityId, toUserId: self.user.uid,
                                  value1: [LIKECOUNT: self.tweet.likeCount - 1],
                                  value2: [User.currentUserId(): FieldValue.delete()])
                self.tweetVC?.viewWillAppear(true)
            }
        }
    }
    
    @objc func tapProfileImageView() {
        
        if let uid = user.uid {
            if uid == User.currentUserId() {
                return
            }
            tweetVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView))
        profileImageVIew.addGestureRecognizer(tap)
        profileImageVIew.layer.cornerRadius = 60 / 2
        contentsImageView.layer.cornerRadius = 15
        
        backView.layer.cornerRadius = 10
        backView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowRadius = 4
    }
}
