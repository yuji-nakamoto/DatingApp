//
//  TweetCommentViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

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
    private var user = User()
    private var users = [User]()
    var tweetId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupBanner()
        testBanner()
        
        setup()
        fetchCommunityId()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: REFRESH2) != nil {
            fetchCommunityId()
            UserDefaults.standard.removeObject(forKey: REFRESH2)
        }
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
                    COMMUNITYID: tweet.communityId as Any,
                    COMMENTID: commentId] as [String : Any]
        
        Tweet.saveTweetComment(communityId: tweet.communityId, tweetId: tweetId, commentId: commentId, withValue: dict)
        Tweet.updateCommentCount(communityId: tweet.communityId, tweetId: tweetId, withValue: [COMMENTCOUNT: tweet.commentCount + 1])
        sendButton.isEnabled = true
        textField.resignFirstResponder()
        textField.text = ""
        fetchTweetComment(tweet)
        UserDefaults.standard.set(true, forKey: REFRESH)
    }
    
    // MARK: - Fetch
    
    private func fetchCommunityId() {
        
        Tweet.fetchCommunityId(tweetId: tweetId) { (tweet) in
            self.tweet = tweet
            self.fetchUser(self.tweet)
            self.fetchTweet(self.tweet)
            self.fetchTweetComment(self.tweet)
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser(_ tweet: Tweet) {
        
        User.fetchUser(tweet.uid) { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchTweet(_ tweet: Tweet) {
        
        Tweet.fetchTweet(communityId: tweet.communityId, tweetId: tweetId) { (tweet) in
            self.tweet = tweet
            self.tweet2 = tweet
            self.tableView.reloadData()
        }
    }
    
    private func fetchTweetComment(_ tweet: Tweet) {
        
        tweetComments.removeAll()
        users.removeAll()
        
        Tweet.fetchTweetComment(communityId: tweet.communityId, tweetId: tweetId) { (tweet) in
            
            self.fetchUser(tweet.uid) {
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
    
    // MARK: - Helpers
    
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
        
        let commentNum = 20 - textField.text!.count
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
            detailVC.toUserId = userId
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
        cell2.user = users[indexPath.row - 1]
        cell2.configureCell(tweetComments[indexPath.row - 1], users[indexPath.row - 1])
        return cell2
    }
}
