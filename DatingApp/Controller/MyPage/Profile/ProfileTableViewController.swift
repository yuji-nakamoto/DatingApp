//
//  ProfileTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage
import CoreLocation

class ProfileTableViewController: UIViewController {
    
    // MARK: - Propertis
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var profileImages = [UIImage]()
    private var user = User()
    private var community1 = Community()
    private var community2 = Community()
    private var community3 = Community()
    private var currentLocation: CLLocation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUser()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: REFRESH3)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.fetchCommunity1(self.user)
            self.fetchCommunity2(self.user)
            self.fetchCommunity3(self.user)
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity1(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community1) { (community) in
            self.community1 = community
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity2(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community2) { (community) in
            self.community2 = community
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity3(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community3) { (community) in
            self.community3 = community
            self.tableView.reloadData()
        }
    }

    // MARK: - Helpers
    
    private func configureUI() {

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        editButton.layer.cornerRadius = 44 / 2
        editButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOpacity = 0.3
        editButton.layer.shadowRadius = 4
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommunityUsersVC" {
            let communityUsersVC = segue.destination as! CommunityUsersViewController
            let communityId = sender as! String
            communityUsersVC.communityId = communityId
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
 
        cell.profileVC = self
        cell.user = self.user
        cell.configureCell(self.user)
        cell.configureCommunity1(self.user, self.community1)
        cell.configureCommunity2(self.user, self.community2)
        cell.configureCommunity3(self.user, self.community3)
        
        return cell
    }
}
