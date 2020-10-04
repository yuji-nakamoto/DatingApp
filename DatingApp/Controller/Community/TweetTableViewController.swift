//
//  TweetTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class TweetTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var tweets = [Tweet]()
    private var tweet = Tweet()
    private var users = [User]()
    private var community = Community()
    private let refresh = UIRefreshControl()
    var communityId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupBanner()
        testBanner()
        
        fetchTweet()
        fetchCommunity()
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.removeObject(forKey: RESIZE)
    }
    
    // MARK: - Actions
    
    @objc func refreshTableView(){
        UserDefaults.standard.set(true, forKey: REFRESH_ON)
        fetchTweet()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "CreateTweetVC", sender: communityId)
    }
    
    // MARK: - Fetch
    
    private func fetchTweet() {
        
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            indicator.startAnimating()
        }
        tweets.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Tweet.fetchTweets(communityId: communityId) { (tweet) in
            if tweet.uid == "" {
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
                self.tableView.reloadData()
                return
            }
            
            self.fetchUser(tweet.uid) {
                self.tweets.append(tweet)
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
            }
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchCommunity() {
        
        Community.fetchCommunity(communityId: communityId) { (community) in
            self.community = community
            self.navigationItem.title = "\(self.community.title ?? "")"
        }
    }
    
    // MARK: - Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CreateTweetVC" {
            let createTweetVC = segue.destination as! CreateTweetViewController
            let communityId = sender as! String
            createTweetVC.communityId = communityId
        }
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
        if segue.identifier == "TweetCommentVC" {
            let tweetCommentVC = segue.destination as! TweetCommentViewController
            let tweetId = sender as! String
            tweetCommentVC.tweetId = tweetId
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
}

// MARK: - Table view

extension TweetTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        
        cell.tweetVC = self
        cell.community = self.community
        cell.tweet = tweets[indexPath.row]
        cell.user = users[indexPath.row]
        cell.configureCell(tweets[indexPath.row], users[indexPath.row])
        cell.configureLikeCount()
        
        return cell
    }
}

extension TweetTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: "コミュニティ投稿はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "右下のプラスボタンから投稿してみよう！")
    }
}
