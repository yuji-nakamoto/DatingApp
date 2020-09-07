//
//  InquryInputTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class InquryInputTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    private var user: User!
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "お問い合わせ内容"
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
            self.textView.text = user.inquiry
            self.tableView.reloadData()
        }
    }
        
    // MARK: - Helpers
    
    private func saveTextView() {
        
        if textView.text.count > 500 {
            hud.textLabel.text = "文字数制限になりました。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            
        } else {
            updateUser(withValue: [INQUIRY: textView.text as Any])
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        
        saveButton.layer.cornerRadius = 15
        backView.backgroundColor = .clear
        backView.layer .cornerRadius = 5
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.systemGray.cgColor
        tableView.separatorStyle = .none
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let reportNum = 500 - textView.text.count
        if reportNum < 0 {
            countLabel.text = "文字数制限です"
        } else {
            countLabel.text = String(reportNum)
        }
    }
}
