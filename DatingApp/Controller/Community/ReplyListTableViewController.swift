//
//  ReplyListTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import NVActivityIndicatorView

class ReplyListTableViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var commentReplys = [Tweet]()
    private var users = [User]()
    private let refresh = UIRefreshControl()
    lazy var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 200, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBanner()
//        testBanner()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCommentReply()
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshTableView(){
        UserDefaults.standard.set(true, forKey: REFRESH_ON)
        fetchCommentReply()
    }
    
    // MARK: - Fetch
    
    private func fetchCommentReply() {
        
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            showLoadingIndicator()
        }
        commentReplys.removeAll()
        users.removeAll()
        tableView.reloadData()
        UserDefaults.standard.removeObject(forKey: REFRESH_ON)
        
        Tweet.fetchCommentReplys { [self] (commentReply) in
            if commentReply.uid == "" {
                hideLoadingIndicator()
                refresh.endRefreshing()
                return
            }
            fetchUser(commentReply.uid) {
                commentReplys.insert(commentReply, at: 0)
                hideLoadingIndicator()
                refresh.endRefreshing()
                tableView.reloadData()
            }
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    // MARK: - Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TweetCommentVC" {
            let tweetCommentVC = segue.destination as! TweetCommentViewController
            let tweetId = sender as! String
            tweetCommentVC.tweetId = tweetId
        }
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    private func showLoadingIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator.stopAnimating()
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
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "通知"
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
}

// MARK: - Table view

extension ReplyListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentReplys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTableViewCell
        
        cell.user = users[indexPath.row]
        cell.replyListVC = self
        cell.configureTweetListCell(commentReplys[indexPath.row], users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TweetCommentVC", sender: commentReplys[indexPath.row].tweetId)
    }
}

extension ReplyListTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "リプライの通知はありません", attributes: attributes)
    }
}
