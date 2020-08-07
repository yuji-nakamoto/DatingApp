//
//  SelfIntroTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class SelfIntroTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backView: UIView!
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "自己紹介"
        setupUI()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    
        saveTextView()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(user)
        }
    }
    
    // MARK: - Helpers
    
    private func setupUserInfo(_ user: User) {
        
        textView.text = user.selfIntro
    }
    
    private func saveTextView() {
        
        updateUser(withValue: [SELFINTRO: textView.text as Any])
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        
        backView.backgroundColor = .clear
        backView.layer .cornerRadius = 5
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.separatorStyle = .none
        textView.becomeFirstResponder()
    }
 
}
