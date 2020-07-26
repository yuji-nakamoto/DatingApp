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

        setupUI()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func footStepButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func goodButtonPressed(_ sender: Any) {
        
        
    }
        
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            self.nameLabel.text = user.username
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        nameLabel.text = ""
        profileButton.layer.cornerRadius = 5
        profileButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.shadowOpacity = 0.3
        profileButton.layer.shadowRadius = 4
        profileImageView.layer.cornerRadius = 100 / 2
    }

}
