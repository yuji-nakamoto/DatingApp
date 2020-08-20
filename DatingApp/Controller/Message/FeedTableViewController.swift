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
    @IBOutlet weak var backView: UIView!
    
    private var comments = [Comment]()
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMatchedUser()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        tableView.reloadData()
    }

    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: toInboxCVC()
        case 1: toInboxVC()
        case 2: print("")
        default: break
        }
    }
    
    @objc func refreshCollectionView(){
        fetchMatchedUser()
        refresh.endRefreshing()
    }
    
    // MARK: - Fetch

    private func fetchUsers(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    private func fetchMatchedUser() {

        users.removeAll()
        comments.removeAll()
        
        Match.fetchMatchUsers { (match) in
            if match.uid == "" {
                return
            }
            User.fetchUser(match.uid) { (user) in
                
                guard let uid = match.uid else { return }
                 Comment.fetchComment(toUserId: uid) { (comment) in
                    if comment.uid == "" {
                        return
                    }
                     self.fetchUsers(uid) {
                         self.comments.insert(comment, at: 0)
                         self.tableView.reloadData()
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
    
    private func setupUI() {
        navigationItem.title = "メッセージ"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            backView.backgroundColor = UIColor(named: O_PINK)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            backView.backgroundColor = UIColor(named: O_GREEN)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            backView.backgroundColor = UIColor.white
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            backView.backgroundColor = UIColor(named: O_DARK)
            backView.alpha = 0.85
        }
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
    
    private func toInboxVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let inboxVC = storyboard.instantiateViewController(withIdentifier: "InboxVC") as! InboxTableViewController
        navigationController?.pushViewController(inboxVC, animated: false)
    }
    
    private func toInboxCVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let inboxCVC = storyboard.instantiateViewController(withIdentifier: "InboxCVC") as! InboxCollectionViewController
        navigationController?.pushViewController(inboxCVC, animated: false)
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
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: " マッチしたお相手のひとことが\nこちらに表示されます。", attributes: attributes)
    }
}
