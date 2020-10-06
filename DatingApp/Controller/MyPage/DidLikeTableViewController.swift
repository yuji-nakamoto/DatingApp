//
//  DidLikeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DidLikeTableViewController: UIViewController {
    
    // MARK: - Properties
    
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
        setupBanner()
//        testBanner()
        
        setupUI()
        fetchLikedUsers()
        updateUser(withValue: [NEWLIKE: false])
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
    
    // MARK: - Fetch
    
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
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    // MARK: - Helpers
    
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
        navigationItem.title = "いいね"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}

// MARK: - Table view

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
