//
//  MessageTebleViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class MessageTebleViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var nameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    private var user = User()
    private var currentUser = User()
    private var badgeUser = User()
    private var matchUser = Match()
    private var users = [User]()
    private var messages = [Message]()
    private var interstitial: GADInterstitial!
    var userId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setupUI()
        handleTextField()
        interstitial = createAndLoadIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchMatchUser()
        fetchUser()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        guard userId != "" else { return }
        User.fetchUser(userId) { (user) in
            self.user = user
            Match.fetchMatchUser(toUserId: self.userId) { (match) in
                self.matchUser = match
                if self.matchUser.isMatch == 1 {
                    self.nameLabel.text = "\(self.user.username!)"
                    self.matchLabel.text = "    マッチング済み✨"
                    self.matchLabel.isHidden = false
                } else {
                    self.nameLabel.text = "\(self.user.username!)"
                    self.matchLabel.isHidden = true
                    self.nameLabelTopConstraint.constant = 50
                }
            }
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
    
    private func fetchMatchUser() {
        guard userId != "" else { return }
        Match.fetchMatchUser(toUserId: userId) { (match) in
            self.matchUser = match
        }
    }
    
    private func checkIfMatch() {
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            if self.matchUser.isMatch != 1 {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                }
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
        
        incrementAppBadgeCount()
        scrollToBottom()
        textField.text = ""
        sendButton.isEnabled = false
        sendButton.alpha = 0.7
        textField.resignFirstResponder()
        checkIfMatch()
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
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
    }
    
    private func incrementAppBadgeCount() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            
            User.fetchUser(self.userId) { (user) in
                self.badgeUser = user
                
                sendRequestNotification(toUser: self.badgeUser, message: "\(self.currentUser.username!)さんからメッセージが届いています", badge: self.badgeUser.appBadgeCount + 1)
            }
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
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
            navBar.backgroundColor = UIColor(named: O_PINK)
            navBar.alpha = 0.85
            nameLabel.textColor = .white
            backButton.tintColor = .white
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            sendButton.backgroundColor = UIColor(named: O_GREEN)
            sendButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            navBar.backgroundColor = UIColor(named: O_GREEN)
            navBar.alpha = 0.85
            nameLabel.textColor = UIColor(named: O_BLACK)
            backButton.tintColor = UIColor(named: O_BLACK)

        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            sendButton.backgroundColor = UIColor.systemGray4
            sendButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            navBar.backgroundColor = .white
            navBar.alpha = 0.85
            nameLabel.textColor = UIColor(named: O_BLACK)
            backButton.tintColor = UIColor(named: O_BLACK)

        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            sendButton.backgroundColor = UIColor(named: O_DARK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            navBar.backgroundColor = UIColor(named: O_DARK)
            nameLabel.textColor = .white
            backButton.tintColor = .white
            navBar.alpha = 0.85
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
        cell.timeLabel.isHidden = indexPath.row % 3 == 0 ? false : true
        
        return cell
    }
}
