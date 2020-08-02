//
//  MessageTebleViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class MessageTebleViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    private var user = User()
    private var users = [User]()
    private var messages = [Message]()
    var userId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        handleTextField()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        guard userId != "" else { return }
        User.fetchUser(userId) { (user) in
            self.user = user
            self.navigationItem.title = "\(self.user.username!)"
            self.fetchMessage()
        }
    }
    
    private func fetchUser2(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    private func fetchMessage() {
        users.removeAll()
        messages.removeAll()
        
        Message.fetchMessage(forUser: user) { (message) in
            guard let uid = message.to else { return }
            self.fetchUser2(uid) {
                self.messages.append(message)
                self.tableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        let date: Double = Date().timeIntervalSince1970
        let dict = [MESSAGETEXT: textField.text!,
                    FROM: User.currentUserId(),
                    TO: userId,
                    TIMESTAMP: Timestamp(date: Date()),
                    DATE: date] as [String : Any]
        Message.saveMessage(to: user, withValue: dict)
        
        scrollToBottom()
        textField.text = ""
        sendButton.isEnabled = false
        sendButton.alpha = 0.7
        textField.resignFirstResponder()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConstraint.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConstraint.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
            } else {
                viewBottomConstraint.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldDidChange() {
        
        if textField.text != "" {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.7
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        sendButton.layer.cornerRadius = 5
        
        textField.delegate = self
        sendButton.isEnabled = false
        sendButton.alpha = 0.7
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            sendButton.backgroundColor = UIColor(named: O_PINK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            sendButton.backgroundColor = UIColor(named: O_GREEN)
            sendButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            sendButton.backgroundColor = UIColor.systemGray4
            sendButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            sendButton.backgroundColor = UIColor(named: O_DARK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func scrollToBottom() {
        if messages.count > 0 {
            let index = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    private func handleTextField() {
        textField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}

extension MessageTebleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
        cell.message = message
        cell.configureUser(user)
        
        return cell
    }
    
}
