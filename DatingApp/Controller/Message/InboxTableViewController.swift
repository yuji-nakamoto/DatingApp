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

class InboxTableViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBannerView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    
    private var inboxArray = [Inbox]()
    private var inboxArrayDict = [String: Inbox]()
    private var user: User!
    private var interstitial: GADInterstitial!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInbox()
        navigationItem.title = "メッセージ"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        setupBanner()
        interstitial = createAndLoadIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }

    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: navigationController?.popViewController(animated: true)
        case 1: print("")
        default: break
        }
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
    
    private func setupUI() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
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
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
            }
        }
        performSegue(withIdentifier: "MessageVC", sender: inboxArray[indexPath.row].message.chatPartnerId)
    }
}

extension InboxTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        return NSAttributedString(string: " メッセージを送った\nお相手が、\nこちらに表示されます。", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "気になった方のプロフィール欄から、\nメッセージを送ってみましょう。")
    }
}