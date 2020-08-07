//
//  CommentTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//
import UIKit

class CommentTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var user: User!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ひとこと"
        tableView.separatorStyle = .none
        setupKeyboard()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if commentTextField.text!.count > 16 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "ひとことは16文字以下で入力してください。"
            hud.show(in: self.view)
            hud.dismiss()
            return
        } else {
            saveTextField()
        }
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
        
        commentTextField.text = user.comment
    }
    
    private func saveTextField() {
        
        updateUser(withValue: [COMMENT: commentTextField.text as Any])
        navigationController?.popViewController(animated: true)
    }
    
    private func setupKeyboard() {
        
        commentTextField.becomeFirstResponder()
        commentTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
 
}
