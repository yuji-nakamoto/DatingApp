//
//  MyPageTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class MyPageTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var user = User()
    private var myPosts = [Post]()
    private var users = [User]()
    private var comment = Comment()
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupBanner()
        testBanner()
        
        showHintView()
        if UserDefaults.standard.object(forKey: REFRESH3) == nil {
            fetchMyPost()
            fetchUser()
            fetchComment()
            setupUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: REFRESH3) != nil {
            fetchMyPost()
            fetchUser()
            fetchComment()
            setupUI()
            UserDefaults.standard.removeObject(forKey: REFRESH3)
        }
    }
    
    // MARK: - Action
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        removeEffectView()
    }
  
    // MARK: - Fetch
    
    private func fetchUsers(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.resetBadge(self.user)
        }
    }
    
    private func fetchMyPost() {
        
        indicator.startAnimating()
        users.removeAll()
        myPosts.removeAll()
        tableView.reloadData()
        
        Post.fetchMyPost() { (post) in
            if post.uid == "" {
                self.indicator.stopAnimating()
                return
            }
            guard let uid = post.uid else { return }
            self.fetchUsers(uid) {
                self.myPosts.insert(post, at: 0)
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
    
    private func fetchComment() {
        
        Comment.fetchComment(toUserId: User.currentUserId()) { (comment) in
            self.comment = comment
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func resetBadge(_ user: User) {
        
        let totalAppBadgeCount = user.appBadgeCount - user.myPageBadgeCount
        
        updateUser(withValue: [MYPAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
        UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
    }
    
    private func showHintView() {
        
        if UserDefaults.standard.object(forKey: HINT_END) == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                self.visualEffectView.frame = self.view.frame
                self.view.addSubview(self.visualEffectView)
                self.visualEffectView.alpha = 0
                self.view.addSubview(self.hintView)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.visualEffectView.alpha = 1
                    self.hintView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.hintView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: HINT_END)
        }
    }
    
    private func setupUI() {
        navigationItem.title = "マイページ"
        tableView.separatorStyle = .none
        hintView.alpha = 0
        visualEffectView.alpha = 0
        hintView.layer.cornerRadius = 15
        closeButton.layer.cornerRadius = 40 / 2
        hintLabel.text = "マイページからプロフの編集やいいね！等の履歴の確認ができます。\n\n足あとを残したくない、通知を止めたい場合は歯車マークの設定画面で行えます。"
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

extension MyPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPageTableViewCell
            cell.configureCell(user)
            cell.cogAnimation()
            cell.myPageVC = self
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! PostTableViewCell
        
        let myPost = myPosts[indexPath.row - 1]
        cell.myPageVC = self
        cell.post = myPost
        cell.configureUserCell(users[indexPath.row - 1])
        
        return cell
    }
}
