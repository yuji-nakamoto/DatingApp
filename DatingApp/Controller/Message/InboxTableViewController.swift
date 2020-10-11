//
//  InboxTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/06.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import NVActivityIndicatorView

class InboxTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var inboxArray = [Inbox]()
    private var inboxArrayDict = [String: Inbox]()
    private let refresh = UIRefreshControl()
    private var user = User()
    private var users = [User]()
    private var matches = [Match]()
    private var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupIndicator()
        fetchUser()
        fetchInbox()
        fetchMatchUsers()
        updateUser(withValue: [NEWMESSAGE: false])
        
        setupBanner()
//        testBanner()
    }
    
    @objc func refreshCollectionView(){
        UserDefaults.standard.set(true, forKey: REFRESH_ON)
        fetchMatchUsers()
        fetchInbox()
    }
    
    // MARK: - Fetch
    
    private func fetchMatchUsers() {
        
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            showLoadingIndicator()
        }
        matches.removeAll()
        users.removeAll()
        
        Match.fetchMatchUsers { (match) in
            if match.uid == "" {
                self.refresh.endRefreshing()
                self.hideLoadingIndicator()
                return
            }
            guard let uid = match.uid else { return }
            self.fetchUser(uid: uid) {
                self.matches.append(match)
                self.collectionView.reloadData()
                self.hideLoadingIndicator()
                self.refresh.endRefreshing()
                UserDefaults.standard.removeObject(forKey: REFRESH_ON)
            }
        }
    }

    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchInbox() {
        
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            showLoadingIndicator()
        }
        Message.fetchInbox { (inboxs) in
            inboxs.forEach { (inbox) in
                let message = inbox.message
                self.inboxArrayDict[message.chatPartnerId] = inbox
            }
            self.inboxArray = Array(self.inboxArrayDict.values)
            self.tableView.reloadData()
            self.hideLoadingIndicator()
            self.refresh.endRefreshing()
            UserDefaults.standard.removeObject(forKey: REFRESH_ON)
        }
    }
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.resetBadge(self.user)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let toUserId = sender as! String
            messageVC.toUserId = toUserId
        }
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    // MARK: - Helper
    
    private func resetBadge(_ user: User) {
        
        let totalAppBadgeCount = user.appBadgeCount - user.messageBadgeCount
        
        updateUser(withValue: [MESSAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
        UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
    }
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func setupIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 250, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
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
    
    private func setupUI() {
        navigationItem.title = "メッセージ"
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
}

// MARK: - Collection view

extension InboxTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MatchCollectionViewCell
        
        cell.configureMacthCell(users[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MessageVC", sender: users[indexPath.row].uid)
    }
}

// MARK: - Table view

extension InboxTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let inbox = inboxArray[indexPath.row]
        cell.inbox = inbox
        cell.inboxVC = self
        cell.configureInboxCell(inboxArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MessageVC", sender: inboxArray[indexPath.row].message.chatPartnerId)
    }
}

extension InboxTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "上部にマッチしたお相手が、\n下部にメッセージを送ったお相手が\n表示されます", attributes: attributes)
    }
}
