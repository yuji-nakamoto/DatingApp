//
//  FootstepTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FootstepTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var footsteps = [Footstep]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchtFootstepedUsers()
        
        setupBanner()
//        testBanner()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchtFootstepedUsers()
        case 1: fetchIsFootstepUsers()
        default: break
        }
    }

    // MARK: - Fetch
    
    private func fetchIsFootstepUsers() {
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        footsteps.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Footstep.fetchFootstepUsers { (footstep) in
            if footstep.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = footstep.uid else { return }
            self.fetchUser(uid: uid) {
                self.footsteps.insert(footstep, at: 0)
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchtFootstepedUsers() {
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        footsteps.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Footstep.fetchFootstepedUsers { (footstep) in
            if footstep.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = footstep.uid else { return }
            self.fetchUser(uid: uid) {
                self.footsteps.insert(footstep, at: 0)
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
        navigationItem.title = "足あと"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}

// MARK: - Table view data source

extension FootstepTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return footsteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let footstep = footsteps[indexPath.row]
        cell.footstep = footstep
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: footsteps[indexPath.row].uid)
    }
}
