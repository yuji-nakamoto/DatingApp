//
//  ReplyViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/02.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var tweet = Tweet()
    private var user = User()
    private var currentUser = User()
    var commentId = ""
    var timestamp: String {
        let date = tweet.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchTweetComment()
        fetchCurrentUser()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        sendButton.isEnabled = false
        
        let replyId = UUID().uuidString
        let date: Double = Date().timeIntervalSince1970
        let dict = [REPLY: textField.text as Any,
                    REPLYID: replyId,
                    DATE2: date,
                    REPLYUSERID: User.currentUserId(),
                    ISREPLY: true] as [String : Any]
        
        Tweet.updateTweetComment(tweetId: tweet.tweetId, commentId: commentId, withValue: dict)
        Tweet.saveCommentReply(commentId: commentId, userId: user.uid, withValue: [UID: User.currentUserId(),
                                                                                   COMMENT: textField.text as Any,
                                                                                   TWEETID: tweet.tweetId as Any,
                                                                                   DATE: date])
        
        incrementAppBadgeCount()
        UserDefaults.standard.set(true, forKey: REFRESH2)
        textField.text = ""
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchTweetComment() {
        guard commentId != "" else { return }
        Tweet.fetchTweetComment(commentId: commentId) { (tweet) in
            
            self.fetchUser(tweet.uid) {
                self.tweet = tweet
                self.timeLabel.text = self.timestamp
                self.commentLabel.text = self.tweet.comment
            }
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.user = user
            self.nameLabel.text = self.user.username
            self.profileImageView.sd_setImage(with: URL(string: self.user.profileImageUrl1), completed: nil)
            completion()
        }
    }
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
        }
    }
    
    // MARK: - Helpers
    
    private func incrementAppBadgeCount() {
   
        sendRequestNotification6(toUser: self.user,
                                message: "\(self.currentUser.username!)さんからリプライです",
                                badge: self.user.appBadgeCount + 1)
        updateToUser(self.user.uid, withValue: [NEWREPLY: true])
    }
    
    private func setup() {
        navigationItem.title = "リプライ"
        nameLabel.text = ""
        commentLabel.text = ""
        timeLabel.text = ""
        sendButton.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = 50 / 2
        textField.becomeFirstResponder()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConstraint.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConstraint.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
            } else {
                viewBottomConstraint.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldDidChange() {
        
        let commentNum = 30 - textField.text!.count
        if commentNum < 0 {
            countLabel.text = "×"
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
        } else {
            countLabel.text = String(commentNum)
            if textField.text == "" {
                sendButton.isEnabled = false
                sendButton.alpha = 0.5
            } else {
                sendButton.isEnabled = true
                sendButton.alpha = 1
            }
        }
    }
}
