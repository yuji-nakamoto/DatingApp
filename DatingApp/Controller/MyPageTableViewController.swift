//
//  MyPageTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MyPageTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var goodButton: UIStackView!
    @IBOutlet weak var cogButton: UIStackView!
    @IBOutlet weak var footStepButton: UIStackView!
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColor()
        setupUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! UINavigationController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            self.nameLabel.text = user.username
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        nameLabel.text = ""
        profileButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 100 / 2
        navigationItem.title = "マイページ"
    }
    
    private func setupColor() {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            profileButton.backgroundColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            tabBarController?.tabBar.barTintColor = UIColor(named: O_PINK)
        } else {
            profileButton.backgroundColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
            tabBarController?.tabBar.barTintColor = UIColor(named: O_GREEN)
        }
    }
    
}
