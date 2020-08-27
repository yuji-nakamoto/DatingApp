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

class InboxTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    
    private var inboxArray = [Inbox]()
    private var inboxArrayDict = [String: Inbox]()
    private let refresh = UIRefreshControl()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInbox()
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
        case 1: break
        case 2: performSegue(withIdentifier: "FeedVC", sender: nil)
        default: break
        }
    }
    
    @objc func refreshCollectionView(){
        fetchInbox()
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
            self.refresh.endRefreshing()
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
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    // MARK: - Helper
        
    private func setupBanner() {
        
        // test adUnitID
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setupUI() {
        navigationItem.title = "メッセージ"
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
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
    
    private func toInboxCVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let inboxCVC = storyboard.instantiateViewController(withIdentifier: "InboxCVC") as! InboxCollectionViewController
        navigationController?.pushViewController(inboxCVC, animated: false)
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
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: " メッセージを送った\nお相手が、\nこちらに表示されます。", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "気になった方のプロフィール欄から、\nメッセージを送ってみましょう。")
    }
}
