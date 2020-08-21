//
//  OpinionInputTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class OpinionInputTableViewController: UITableViewController, UITextViewDelegate {
    
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
        navigationItem.title = "ご意見・ご要望・改善等"
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
            self.textView.text = user.opinion
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
            updateUser(withValue: [OPINION: textView.text as Any])
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
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            saveButton.backgroundColor = UIColor(named: O_PINK)
            saveButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            saveButton.backgroundColor = UIColor(named: O_GREEN)
            saveButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            saveButton.backgroundColor = UIColor(named: O_GREEN)
            saveButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            saveButton.backgroundColor = UIColor(named: O_DARK)
            saveButton.setTitleColor(UIColor.white, for: .normal)
        }
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
