//
//  HobbyTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class HobbyTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var hobbyTextField1: UITextField!
    @IBOutlet weak var hobbyTextField2: UITextField!
    @IBOutlet weak var hobbyTextField3: UITextField!
    @IBOutlet weak var hobbyCountLabel1: UILabel!
    @IBOutlet weak var hobbyCountLabel2: UILabel!
    @IBOutlet weak var hobbyCountLabel3: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var hud = JGProgressHUD(style: .dark)
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!], for: .normal)
        navigationItem.title = "趣味"
        tableView.separatorStyle = .none
        setupKeyboard()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if hobbyTextField1.text!.count > 10 || hobbyTextField2.text!.count > 10 || hobbyTextField3.text!.count > 10 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "趣味は10文字以下で入力してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
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
        
        hobbyTextField1.text = user.hobby1
        hobbyTextField2.text = user.hobby2
        hobbyTextField3.text = user.hobby3
        hobbyCountLabel1.text = String(10 - hobbyTextField1.text!.count)
        hobbyCountLabel2.text = String(10 - hobbyTextField2.text!.count)
        hobbyCountLabel3.text = String(10 - hobbyTextField3.text!.count)
    }
    
    private func saveTextField() {
        
        let dict = [HOBBY1: hobbyTextField1.text,
                    HOBBY2: hobbyTextField2.text,
                    HOBBY3: hobbyTextField3.text]
        updateUser(withValue: dict as [String : Any])
        navigationController?.popViewController(animated: true)
    }
    
    private func setupKeyboard() {
        
        hobbyTextField1.becomeFirstResponder()
        hobbyTextField1.delegate = self
        hobbyTextField2.delegate = self
        hobbyTextField3.delegate = self
        hobbyTextField1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        hobbyTextField2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        hobbyTextField3.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
                
        let hobbyNum1 = 10 - hobbyTextField1.text!.count
        if hobbyNum1 < 0 {
            hobbyCountLabel1.text = "文字数制限です"
        } else {
            hobbyCountLabel1.text = String(hobbyNum1)
        }
        
        let hobbyNum2 = 10 - hobbyTextField2.text!.count
        if hobbyNum2 < 0 {
            hobbyCountLabel2.text = "文字数制限です"
        } else {
            hobbyCountLabel2.text = String(hobbyNum2)
        }
        
        let hobbyNum3 = 10 - hobbyTextField3.text!.count
        if hobbyNum3 < 0 {
            hobbyCountLabel3.text = "文字数制限です"
        } else {
            hobbyCountLabel3.text = String(hobbyNum3)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
