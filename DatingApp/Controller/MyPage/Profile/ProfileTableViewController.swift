//
//  ProfileTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileTableViewController: UIViewController {
    
    // MARK: - Propertis
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var profileImages = [UIImage]()
    var user = User()
    
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
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
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
        if UserDefaults.standard.object(forKey: PINK) != nil {
            editButton.backgroundColor = UIColor(named: O_PINK)
            editButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            editButton.backgroundColor = UIColor(named: O_GREEN)
            editButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            editButton.backgroundColor = UIColor(named: O_GREEN)
            editButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            editButton.backgroundColor = UIColor(named: O_DARK)
            editButton.setTitleColor(UIColor.white, for: .normal)
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
 
        cell.user = self.user
        cell.configureCell(self.user)
        return cell
    }
}
