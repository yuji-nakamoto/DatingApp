//
//  MyCommunityViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/04.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import NVActivityIndicatorView

class MyCommunityViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var user = User()
    private var community1 = Community()
    private var community2 = Community()
    private var community3 = Community()
    private var commuArray = [Community]()
    private var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupBanner()
        testBanner()
        if UserDefaults.standard.object(forKey: REFRESH2) == nil {
            fetchUser()
        }
        setupIndicator()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: REFRESH2) != nil {
            commuArray.removeAll()
            self.fetchUser()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.resetBadge(self.user)
            self.fetchCommunity1(self.user)
            self.fetchCommunity2(self.user)
            self.fetchCommunity3(self.user)
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity1(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community1) { (community) in
          
            self.community1 = community
            self.commuArray.append(self.community1)
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity2(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community2) { (community) in
  
            self.community2 = community
            self.commuArray.append(self.community2)
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity3(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community3) { (community) in
        
            self.community3 = community
            self.commuArray.append(self.community3)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
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
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 150, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TweetVC" {
            let tweetVC = segue.destination as! TweetTableViewController
            let communityId = sender as! String
            tweetVC.communityId = communityId
        }
        
        if segue.identifier == "CommunityUsersVC" {
            let communityUsersVC = segue.destination as! CommunityUsersViewController
            let communityId = sender as! String
            communityUsersVC.communityId = communityId
        }
    }
    
    private func setup() {
        navigationItem.title = "マイコミュニティ"
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        updateUser(withValue: [NEWREPLY: false])
    }
    
    private func resetBadge(_ user: User) {
        
        let totalAppBadgeCount = user.appBadgeCount - user.communityBadgeCount
        
        updateUser(withValue: [COMMUNITYBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
        UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
    }
}

// MARK: - Table view
extension MyCommunityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyCommunityTableViewCell
        
        cell.myCommunityVC = self
        cell.user = user
        cell.community = commuArray[indexPath.row]
        cell.configureCell(commuArray[indexPath.row])
        return cell
    }
}

extension MyCommunityViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "参加しているコミュニティはありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "気になるコミュニティに参加してみよう！", attributes: attributes)
    }
}
