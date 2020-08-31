//
//  HobbyTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class HobbyTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var hobbyTextField1: UITextField!
    @IBOutlet weak var hobbyTextField2: UITextField!
    @IBOutlet weak var hobbyTextField3: UITextField!
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "趣味"
        tableView.separatorStyle = .none
        setupKeyboard()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveTextField()
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
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        }
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
