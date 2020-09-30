//
//  TweetCommentTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class TweetCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var user = User()
    var tweet = Tweet()
    var tweet2 = Tweet()
    var tweetCommentVC: TweetCommentViewController?
    
    func configureCell(_ tweet: Tweet, _ user: User) {
        
        let date = Date(timeIntervalSince1970: tweet.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        
        nameLabel.text = user.username
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        commentLabel.text = tweet.comment
        timeLabel.text = dateString
        
        if tweet.uid == User.currentUserId() {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "コメントを削除しますか？", preferredStyle: .alert)
        let delete: UIAlertAction = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in
            
            Tweet.deleteComment(communityId: self.tweet.communityId, tweetId: self.tweetCommentVC!.tweetId, commentId: self.tweet.commentId)
            Tweet.updateCommentCount(communityId: self.tweet.communityId, tweetId: self.tweetCommentVC!.tweetId, withValue: [COMMENTCOUNT: self.tweet2.commentCount - 1])
            UserDefaults.standard.set(true, forKey: REFRESH)
            UserDefaults.standard.set(true, forKey: REFRESH2)
            self.tweetCommentVC?.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        tweetCommentVC?.present(alert,animated: true,completion: nil)
    }
    
    @objc func tapProfileImageView() {
        
        if let uid = user.uid {
            if uid == User.currentUserId() { return }
            tweetCommentVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.layer.cornerRadius = 60 / 2
        nameLabel.text = ""
        timeLabel.text = ""
        commentLabel.text = ""
    }
}
