//
//  DetailAreaTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class DetailAreaTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var detailMapTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
    
    private var user: User!
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細エリア"
        tableView.separatorStyle = .none
        saveButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!], for: .normal)
        setupKeyboard()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
       if detailMapTextField.text!.count > 4 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "4文字以下で入力してください"
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
        
        detailMapTextField.text = user.detailArea
        countLabel.text = String(4 - detailMapTextField.text!.count)
    }
    
    private func saveTextField() {
        
        updateUser(withValue: [DETAILAREA: detailMapTextField.text as Any])
        navigationController?.popViewController(animated: true)
    }
    
    private func setupKeyboard() {
        
        detailMapTextField.becomeFirstResponder()
        detailMapTextField.delegate = self
        detailMapTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
                
        let areaNum = 4 - detailMapTextField.text!.count
        if areaNum < 0 {
            countLabel.text = "文字数制限です"
        } else {
            countLabel.text = String(areaNum)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
