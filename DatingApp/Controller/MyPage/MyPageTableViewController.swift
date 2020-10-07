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
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var redMarkView: UIView!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyPost()
        fetchUser()
        fetchComment()
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        
        User.fetchUserAddSnapshotListener { (user) in
            self.user = user
            self.resetBadge(self.user)
            self.checkMission(self.user)
        }
    }
    
    private func fetchMyPost() {
        
        users.removeAll()
        myPosts.removeAll()
        tableView.reloadData()
        
        Post.fetchMyPost() { (post) in
            if post.uid == "" {
                return
            }
            guard let uid = post.uid else { return }
            self.fetchUsers(uid) {
                self.myPosts.insert(post, at: 0)
                self.tableView.reloadData()
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
    
    private func checkMission(_ user: User) {
        
        if user.missionClearGetItem {
            updateUser(withValue: [NEWMISSION: false])
            return
        }
        
        if user.loginGetPt1 != true {
            if user.mLoginCount >= 14 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.loginGetPt2 != true {
            if user.mLoginCount >= 28 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.likeGetPt1 != true {
            if user.mLikeCount >= 25 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.likeGetPt2 != true {
            if user.mLikeCount >= 50 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.typeGetPt1 != true {
            if user.mTypeCount >= 10 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.typeGetPt2 != true {
            if user.mTypeCount >= 30 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.messageGetPt1 != true {
            if user.mMessageCount >= 5 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.messageGetPt2 != true {
            if user.mMessageCount >= 15 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.matchGetPt1 != true {
            if user.mMatchCount >= 1 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.matchGetPt2 != true {
            if user.mMatchCount >= 5 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.footGetPt1 != true {
            if user.mFootCount >= 50 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.footGetPt2 != true {
            if user.mFootCount >= 100 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.communityGetPt1 != true {
            if user.mCommunityCount >= 1 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.communityGetPt2 != true {
            if user.mCommunityCount >= 3 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.communityGetPt3 != true {
            if user.createCommunityCount >= 1 {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.communityGetPt4 != true {
            if user.mCommunity == true {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.profileGetPt1 != true {
            if user.mProfile == true {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.kaiganGetPt != true {
            if user.mKaigan == true {
                updateUser(withValue: [NEWMISSION: true])
            }
        }

        if user.toshiGetPt != true {
            if user.mToshi == true {
                updateUser(withValue: [NEWMISSION: true])
            }
        }
        
        if user.missionClearGetItem != true {
            if user.mLoginCount >= 28 && user.mLikeCount >= 50 && user.mTypeCount >= 30 && user.mMessageCount >= 15 && user.mMatchCount >= 5 && user.mFootCount >= 100 && user.mCommunityCount >= 3 && user.mCommunity == true && user.createCommunityCount >= 1 && user.mProfile == true && user.mKaigan == true && user.mToshi == true {
                updateUser(withValue: [MMISSIONCLEAR: true, NEWMISSION: true])
            }
        }
    }
    
    private func setupUI() {
        
        tableView.separatorStyle = .none
        hintView.alpha = 0
        visualEffectView.alpha = 0
        redMarkView.layer.cornerRadius = 4
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
