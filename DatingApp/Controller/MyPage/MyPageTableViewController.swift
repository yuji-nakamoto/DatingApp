//
//  MyPageTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MyPageTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var currentUser = User()
    private var user = User()
    private var myPosts = [Post]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "マイページ"
        tableView.separatorStyle = .none
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        fetchMatchedUser()
        resetBadge()
        UserDefaults.standard.set(true, forKey: FEED)
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            fetchMatchedUser()
            UserDefaults.standard.set(true, forKey: FEED)

        case 1:
            fetchMyPost()
            UserDefaults.standard.removeObject(forKey: FEED)

        default: break
        }
    }
    
    // MARK: - Fetch
    
    private func fetchUsers(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    private func fetchMyPost() {
        
        users.removeAll()
        myPosts.removeAll()
        tableView.reloadData()
        
        Post.fetchMyPost() { (post) in
            guard let uid = post.uid else { return }
            self.fetchUsers(uid) {
                self.myPosts.insert(post, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchMatchedUser() {
        
        users.removeAll()
        myPosts.removeAll()
        tableView.reloadData()

        Match.fetchMatchUser { (match) in
            User.fetchUser(match.uid) { (user) in
                self.user = user
            }
            guard let uid = match.uid else { return }
            Post.fetchFeed(matchedUserId: uid) { (feed) in
                self.fetchUsers(uid) {
                    self.myPosts.insert(feed, at: 0)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func resetBadge() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.tableView.reloadData()
            let totalAppBadgeCount = user.appBadgeCount - user.myPageBadgeCount
            
            updateUser(withValue: [MYPAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
            UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
            self.tabBarController!.viewControllers![4].tabBarItem.badgeValue = nil
        }
    }
    
    private func setupUI() {
        
        segmentControl.selectedSegmentIndex = 0

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
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

// MARK: - Table view

extension MyPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPageTableViewCell
            cell.configureCell(currentUser)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! PostTableViewCell
        
        let myPost = myPosts[indexPath.row - 1]
        cell.post = myPost
        
        if UserDefaults.standard.object(forKey: FEED) != nil {
            cell.configureUserCell(users[indexPath.row - 1])
        } else {
            cell.configureCurrentUserCell(currentUser)
        }
        return cell
    }
}
