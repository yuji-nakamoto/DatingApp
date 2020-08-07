//
//  NicknameTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//
import UIKit

class NicknameTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ニックネーム"
        tableView.separatorStyle = .none
        setupKeyboard()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if nickNameTextField.text == "" {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "1文字以上入力してください。"
            hud.show(in: self.view)
            hud.dismiss()
            return
        } else if nickNameTextField.text!.count > 10 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "名前は10文字以下で入力してください。"
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
        
        nickNameTextField.text = user.username
    }
    
    private func saveTextField() {
        
        updateUser(withValue: [USERNAME: nickNameTextField.text as Any])
        navigationController?.popViewController(animated: true)
    }
    
    private func setupKeyboard() {
        
        nickNameTextField.becomeFirstResponder()
        nickNameTextField.delegate = self
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
 
}
