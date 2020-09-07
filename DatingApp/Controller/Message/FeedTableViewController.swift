//
//  FeedTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/17.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class FeedTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var comments = [Comment]()
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBanner()
//        testBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMatchedUser()
    }

    @objc func refreshCollectionView(){
        UserDefaults.standard.set(true, forKey: REFRESH_ON)
        fetchMatchedUser()
    }
    
    // MARK: - Fetch
    
    private func fetchUsers(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    private func fetchMatchedUser() {
        
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            indicator.startAnimating()
        }
        users.removeAll()
        comments.removeAll()
        
        Match.fetchMatchUsers { (match) in
            if match.uid == "" {
                self.refresh.endRefreshing()
                self.indicator.stopAnimating()
                UserDefaults.standard.removeObject(forKey: REFRESH_ON)
                return
            }
            User.fetchUser(match.uid) { (user) in
                
                guard let uid = match.uid else { return }
                Comment.fetchComment(toUserId: uid) { (comment) in
                    if comment.uid == "" {
                        self.refresh.endRefreshing()
                        self.indicator.stopAnimating()
                        UserDefaults.standard.removeObject(forKey: REFRESH_ON)
                        return
                    }
                    self.fetchUsers(uid) {
                        self.comments.insert(comment, at: 0)
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                        self.indicator.stopAnimating()
                        UserDefaults.standard.removeObject(forKey: REFRESH_ON)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    
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
    
    private func setupUI() {
        navigationItem.title = "メッセージ"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let toUserId = sender as! String
            messageVC.toUserId = toUserId
        }
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
}

// MARK: - Table view

extension FeedTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        cell.configureUserCell(users[indexPath.row])
        cell.user = users[indexPath.row]
        cell.feedVC = self
        cell.comment = comments[indexPath.row]
        
        return cell
    }
}

extension FeedTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: " マッチしたお相手のひとことが\nこちらに表示されます。", attributes: attributes)
    }
}
