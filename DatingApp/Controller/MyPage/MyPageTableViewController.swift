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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    private var currentUser = User()
    private var user = User()
    private var myPosts = [Post]()
    private var users = [User]()
    private var comment = Comment()
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "マイページ"
        tableView.separatorStyle = .none
        setupBanner()
        showHintView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.removeObject(forKey: VIEW_ON)
        if segmentControl.selectedSegmentIndex == 1 {
            fetchMyPost()
        }
        fetchComment()
        resetBadge()
        setupUI()
    }
    
    // MARK: - Action
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        removeEffectView()
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            users.removeAll()
            myPosts.removeAll()
            tableView.reloadData()
        case 1:
            fetchMyPost()

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
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        users.removeAll()
        myPosts.removeAll()
        tableView.reloadData()
        
        Post.fetchMyPost() { (post) in
            if post.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = post.uid else { return }
            self.fetchUsers(uid) {
                self.myPosts.insert(post, at: 0)
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.segmentControl.isEnabled = true
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
                
        hintView.alpha = 0
        visualEffectView.alpha = 0
        hintView.layer.cornerRadius = 15
        closeButton.layer.cornerRadius = 40 / 2
        hintLabel.text = "マイページからプロフの編集やいいね！等の履歴の確認ができます。\n\n足あとを残したくない、通知を止めたい場合は歯車マークの設定画面で行えます。"
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
        
        // test adUnitID
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
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
            cell.cogAnimation()
            cell.myPageVC = self
            cell.configureCommentCell(comment)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! PostTableViewCell
        
        let myPost = myPosts[indexPath.row - 1]
        cell.post = myPost
        
        if segmentControl.selectedSegmentIndex == 1 {
            cell.configureUserCell(users[indexPath.row - 1])
        } 
        return cell
    }
}
