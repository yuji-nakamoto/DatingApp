//
//  TweetCommentTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class TweetCommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var replyUserImageView: UIImageView!
    @IBOutlet weak var replyNameLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var replyTimeLabel: UILabel!
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var likeCountLabel2: UILabel!
    @IBOutlet weak var deleteButton2: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var deleteBtnLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeBtn2BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeBtn2TopConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineViewHeight: NSLayoutConstraint!
    
    var tweet = Tweet()
    var tweet2 = Tweet()
    var tweetCommentVC: TweetCommentViewController?
    
    // MARK: - Cell
    
    func configureCell(_ tweet: Tweet, _ user: User, _ mainTweet: Tweet) {
        
        let date = Date(timeIntervalSince1970: tweet.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        
        nameLabel.text = user.username
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        commentLabel.text = tweet.comment
        timeLabel.text = dateString
        
        if tweet.likeCount == nil { return }
        likeCountLabel.text = String(tweet.likeCount)
        
        if mainTweet.uid == User.currentUserId() && tweet.uid != User.currentUserId() {
            deleteButton.isHidden = true
            commentButton.isHidden = false
        } else if tweet.uid == User.currentUserId() {
            
            deleteButton.isHidden = false
            commentButton.isHidden = true
            deleteBtnLeftConstraint.constant = -20
        } else {
            
            deleteButton.isHidden = true
            commentButton.isHidden = true
        }
    }
    
    func configureReplyCell(_ tweet: Tweet, _ user: User) {
        
        if tweet.isReply == true {
            
            let date = Date(timeIntervalSince1970: tweet.date2)
            let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            
            setupUIAppearance()
            replyLabel.text = tweet.reply
            replyNameLabel.text = user.username
            replyTimeLabel.text = dateString
            likeCountLabel2.text = String(tweet.likeCount2)
            replyUserImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            
            if tweet.replyUserId == User.currentUserId() {
                deleteButton2.isHidden = false
            } else if tweet.replyUserId != User.currentUserId() {
                deleteButton2.isHidden = true
            }
        } else {
            setupUIHiddien()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        Tweet.checkIsLike1Comment(tweetId: tweet.tweetId, commentId: tweet.commentId ) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                
                self.likeButton.setImage(UIImage(named: "heart3"), for: .normal)
                self.likeCountLabel.text = String(self.tweet.likeCount + 1)
                Tweet.updateIsLike1Comment(tweetId: self.tweet.tweetId, commentId: self.tweet.commentId,
                                  value1: [LIKECOUNT: self.tweet.likeCount + 1],
                                  value2: [User.currentUserId(): true])
            }
        }
    }
    
    @IBAction func likeButtonPressed2(_ sender: Any) {
        
        Tweet.checkIsLike2Comment(tweetId: tweet.tweetId, commentId: tweet.commentId ) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                
                self.likeButton2.setImage(UIImage(named: "heart3"), for: .normal)
                self.likeCountLabel2.text = String(self.tweet.likeCount2 + 1)
                Tweet.updateIsLike2Comment(tweetId: self.tweet.tweetId, commentId: self.tweet.commentId,
                                  value1: [LIKECOUNT2: self.tweet.likeCount2 + 1],
                                  value2: [User.currentUserId(): true])
            }
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        
        if let uid = tweet.commentId {
            tweetCommentVC?.performSegue(withIdentifier: "ReplyVC", sender: uid)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "削除", message: "コメントを削除しますか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in

            Tweet.deleteComment(tweetId: self.tweetCommentVC!.tweetId, commentId: self.tweet.commentId) {
                UserDefaults.standard.set(true, forKey: REFRESH2)
                self.tweetCommentVC?.viewWillAppear(true)
            }
            Tweet.updateCommentCount(communityId: self.tweet.communityId,
                                     tweetId: self.tweetCommentVC!.tweetId,
                                     withValue: [COMMENTCOUNT: self.tweet2.commentCount - 1])
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        tweetCommentVC?.present(alert,animated: true,completion: nil)
    }
    
    @IBAction func deleteButtonPressed2(_ sender: Any) {
        
        let alert = UIAlertController(title: "削除", message: "リプライを削除しますか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in
            
            let dict = [REPLY: FieldValue.delete(),
                        REPLYID: FieldValue.delete(),
                        DATE2: FieldValue.delete(),
                        ISREPLY: false] as [String : Any]
            
            Tweet.updateTweetComment(tweetId: self.tweet.tweetId, commentId: self.tweet.commentId, withValue: dict)
            UserDefaults.standard.set(true, forKey: REFRESH2)
            self.tweetCommentVC?.viewWillAppear(true)
            self.setupUIHiddien()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        tweetCommentVC?.present(alert,animated: true,completion: nil)
    }
    
    @objc func tapProfileImageView() {
        
        if let uid = tweet.uid {
            if uid == User.currentUserId() { return }
            tweetCommentVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
        }
    }
    
    @objc func tapCommentLabel() {
        guard tweet.uid != User.currentUserId() else { return }
        if let uid = tweet.commentId {
            tweetCommentVC?.performSegue(withIdentifier: "ReplyVC", sender: uid)
        }
    }
    
    // MARK: - Helpers
    
    func configureIsLikeCount() {
        
        Tweet.checkIsLike1Comment(tweetId: tweet.tweetId, commentId: tweet.commentId) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                self.likeButton.setImage(UIImage(named: "heart2"), for: .normal)
            } else {
                self.likeButton.setImage(UIImage(named: "heart3"), for: .normal)
            }
        }
        
        Tweet.checkIsLike2Comment(tweetId: tweet.tweetId, commentId: tweet.commentId) { (likeUserIDs) in
            if likeUserIDs[User.currentUserId()] == nil {
                self.likeButton2.setImage(UIImage(named: "heart2"), for: .normal)
            } else {
                self.likeButton2.setImage(UIImage(named: "heart3"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapCommentLabel))
        profileImageView.addGestureRecognizer(tap1)
        commentLabel.addGestureRecognizer(tap2)
        profileImageView.layer.borderWidth = 3
        replyUserImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor(named: "original_white")?.cgColor
        replyUserImageView.layer.borderColor = UIColor(named: "original_white")?.cgColor
        profileImageView.layer.cornerRadius = 55 / 2
        replyUserImageView.layer.cornerRadius = 55 / 2
        replyNameLabel.text = ""
        replyTimeLabel.text = ""
        replyLabel.text = ""
        likeCountLabel2.text = ""
        nameLabel.text = ""
        timeLabel.text = ""
        commentLabel.text = ""
        replyUserImageView.image = nil
        lineView.isHidden = true
        likeButton2.isHidden = true
        deleteButton2.isHidden = true
        likeBtn2TopConstraint.constant = 0
        likeBtn2BottomConstraint.constant = -35
        replyNameTopConstraint.constant = 0
        replyLblTopConstraint.constant = 0
    }
    
    func setupUIAppearance() {
        lineView.isHidden = false
        likeButton2.isHidden = false
        deleteButton2.isHidden = false
        likeBtn2TopConstraint.constant = 10
        likeBtn2BottomConstraint.constant = 7
        replyNameTopConstraint.constant = 20
        replyLblTopConstraint.constant = 10
    }
    
    func setupUIHiddien() {
        replyNameLabel.text = ""
        replyTimeLabel.text = ""
        replyLabel.text = ""
        replyUserImageView.image = nil
        lineView.isHidden = true
        likeButton2.isHidden = true
        deleteButton2.isHidden = true
        likeBtn2TopConstraint.constant = 0
        likeBtn2BottomConstraint.constant = -35
        replyNameTopConstraint.constant = 0
        replyLblTopConstraint.constant = 0
    }
}
