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
    
    private var user: User!
    private var myPosts = [Post]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "マイページ"
        tableView.separatorStyle = .none
        setupBanner()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMyPost()
        fetchCurrentUser()
        resetBadge()
    }
    
    // MARK: - Fetch user
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    // MARK: - Fetch my post
    
    private func fetchMyPost() {
        
        users.removeAll()
        myPosts.removeAll()
        
        Post.fetchMyPost() { (post) in
            guard let uid = post.uid else { return }
            self.fetchUser(uid) {
                self.myPosts.insert(post, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func resetBadge() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let totalAppBadgeCount = user.appBadgeCount - user.myPageBadgeCount
            
            updateUser(withValue: [MYPAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
            UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
            self.tabBarController!.viewControllers![3].tabBarItem.badgeValue = nil
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
        return 1 + 1 + myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPageTableViewCell
            
            cell.configureCell(user)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! MyPostTableViewCell
            
            cell.bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            cell.bannerView.rootViewController = self
            cell.bannerView.load(GADRequest())
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! PostTableViewCell
        
        let myPost = myPosts[indexPath.row - 2]
        cell.post = myPost
        cell.configureUserCell(user)
        return cell
    }
}
