//
//  InboxTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InboxTableViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBannerView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var inboxArray = [Inbox]()
    private var inboxArrayDict = [String: Inbox]()
    private var user: User!
    private var interstitial: GADInterstitial!


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "メッセージ"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        fetchInbox()
        setupBanner()
        interstitial = createAndLoadIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetBadge()
    }

    // MARK: - Fetch
    
    private func fetchInbox() {
        
        Message.fetchInbox { (inboxs) in
            inboxs.forEach { (inbox) in
                let message = inbox.message
                self.inboxArrayDict[message.chatPartnerId] = inbox
            }
            self.inboxArray = Array(self.inboxArrayDict.values)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let userId = sender as! String
            messageVC.userId = userId
        }
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    // MARK: - Helper
    
    private func resetBadge() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let totalAppBadgeCount = user.appBadgeCount - user.messageBadgeCount
            
            updateUser(withValue: [MESSAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
            UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
            self.tabBarController!.viewControllers![2].tabBarItem.badgeValue = nil
        }
    }
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
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
        if self.interstitial.isReady {
            self.interstitial.present(fromRootViewController: self)
        } else {
            print("Error interstitial")
        }
        performSegue(withIdentifier: "MessageVC", sender: inboxArray[indexPath.row].message.chatPartnerId)
    }
}
