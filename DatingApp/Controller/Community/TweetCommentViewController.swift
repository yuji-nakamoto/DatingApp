//
//  TweetCommentViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import NVActivityIndicatorView

class TweetCommentViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var tweet = Tweet()
    private var tweet2 = Tweet()
    private var tweetComments = [Tweet]()
    private var tweetComment = Tweet()
    private var user = User()
    private var currentUser = User()
    private var reply = Tweet()
    private var users = [User]()
    private let refresh = UIRefreshControl()
    private var activityIndicator: NVActivityIndicatorView?
    var tweetId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanner()
//        testBanner()
        
        setup()
        setupIndicator()
        fetchTweet()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        sendButton.isEnabled = false
        let date: Double = Date().timeIntervalSince1970
        let commentId = UUID().uuidString
        let dict = [UID: User.currentUserId(),
                    COMMENT: textField.text as Any,
                    DATE: date,
                    TIMESTAMP: Timestamp(date: Date()),
                    TWEETID: tweetId,
                    COMMUNITYID: tweet.communityId as Any,
                    COMMENTID: commentId] as [String : Any]
        Tweet.saveTweetComment(tweetId: tweetId, commentId: commentId, withValue: dict)
        Tweet.updateCommentCount(communityId: tweet.communityId,
                                 tweetId: tweetId,
                                 withValue: [COMMENTCOUNT: tweet2.commentCount + 1])
        Tweet.saveCommentReply(commentId: commentId, userId: user.uid, withValue: [UID: User.currentUserId(),
                                                                                   COMMENT: textField.text as Any,
                                                                                   TWEETID: tweetId,
                                                                                   DATE: date])
        textField.resignFirstResponder()
        textField.text = ""
        incrementAppBadgeCount()
        fetchCommentCount(tweet)
    }
    
    // MARK: - Fetch
    
    private func fetchUser(_ tweet: Tweet) {
        
        User.fetchUser(tweet.uid) { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchTweet() {
        
        showLoadingIndicator()
        Tweet.fetchTweet(tweetId: tweetId) { (tweet) in
            if tweet.tweetId == "" {
                self.hideLoadingIndicator()
                return
            }
            self.tweet = tweet
            self.fetchUser(self.tweet)
            self.fetchTweetComment(self.tweet)
            self.fetchCommentCount(self.tweet)
            self.hideLoadingIndicator()
            self.tableView.reloadData()
        }
    }
    
    private func fetchTweetComment(_ tweet: Tweet) {
      
        Tweet.fetchTweetComments(tweetId: tweetId) { (tweet) in
            self.fetchCommentCount(self.tweet)
            self.tweetComments.removeAll()
            self.users.removeAll()
            self.tableView.reloadData()
            
            if tweet.uid == "" {
                self.tableView.reloadData()
                return
            }
            self.fetchUser(tweet.uid) {
                self.tweetComment = tweet
                self.tweetComments.append(tweet)
                self.tableView.reloadData()
            }
        }
    }

    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchCommentCount(_ tweet: Tweet) {
        
        Tweet.fetchTweetCommentCount(communityId: tweet.communityId, tweetId: tweetId) { (tweet2) in
            self.tweet2 = tweet2
            self.tableView.reloadData()
        }
    }
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
        }
    }
    
    // MARK: - Helpers
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func setupIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 100, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
    }
    
    private func incrementAppBadgeCount() {
   
        if user.uid != User.currentUserId() {
            sendRequestNotification7(toUser: self.user,
                                    message: "\(self.currentUser.username!)さんからコメントです",
                                    badge: self.user.appBadgeCount + 1)
            updateToUser(self.user.uid, withValue: [NEWREPLY: true])
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setup() {
        navigationItem.title = "コメント"
        sendButton.alpha = 0.5
        sendButton.isEnabled = false
        tableView.tableFooterView = UIView()
        sendButton.layer.cornerRadius = 10
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
        
        if segue.identifier == "ReplyVC" {
            let replyVC = segue.destination as! ReplyViewController
            let commentId = sender as! String
            replyVC.commentId = commentId
        }
    }
}

// MARK: - Table view

extension TweetCommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + tweetComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TweetTableViewCell
            
            cell.user = self.user
            cell.tweetCommentVC = self
            cell.configureCell(self.tweet, self.user)
            return cell
        }
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! TweetCommentTableViewCell
        
        cell2.tweetCommentVC = self
        cell2.tweet2 = tweet2
        cell2.tweet = tweetComments[indexPath.row - 1]
        cell2.configureCell(tweetComments[indexPath.row - 1], users[indexPath.row - 1], self.tweet)
        cell2.configureReplyCell(tweetComments[indexPath.row - 1], user)
        cell2.configureIsLikeCount()
        return cell2
    }
}
