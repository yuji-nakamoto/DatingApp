//
//  DidLikeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class DidLikeTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var topBannerView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var likeUsers = [Like]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBanner()
        fetchLikedUsers()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segementControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchLikedUsers()
        case 1: fetchLikeUsers()
        default: break
        }
    }
    
    // MARK: - Fetch like
    
    private func fetchLikeUsers() {
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        likeUsers.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Like.fetchLikeUsers { (like) in
            if like.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = like.uid else { return }
            self.fetchUser(uid: uid) {
                self.likeUsers.insert(like, at: 0)
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch liekd
    
    private func fetchLikedUsers() {
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        likeUsers.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Like.fetchLikedUsers { (like) in
            if like.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = like.uid else { return }
            self.fetchUser(uid: uid) {
                self.likeUsers.insert(like, at: 0)
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch user
    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {

            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    // MARK: - Helpers
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        topBannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        navigationItem.title = "いいね"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_PINK)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            backView.backgroundColor = UIColor(named: O_GREEN)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            backView.backgroundColor = UIColor.white
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_DARK)
            backView.alpha = 0.85
        }
    }
}

// MARK: - Table view data source


extension DidLikeTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likeUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let like = likeUsers[indexPath.row]
        cell.like = like
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: likeUsers[indexPath.row].uid)
    }
}

extension DidLikeTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: "いいねされた、\nいいねした履歴が、\nこちらに表示されます。", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "気になった方にいいねを送り、\nアプローチをしてみましょう。")
    }
}
