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
import JGProgressHUD

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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    private var user = User()
    private var currentUser = User()
    private var badgeUser = User()
    private var matchUser = Match()
    private var users = [User]()
    private var messages = [Message]()
    private var interstitial: GADInterstitial!
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var hud = JGProgressHUD(style: .dark)
    var toUserId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setupUI()
        handleTextField()
        hintView()
        interstitial = createAndLoadIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Action
    
    @objc func handleDismissal() {
        removeEffectView()
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        guard toUserId != "" else { return }
        User.fetchUser(toUserId) { (user) in
            self.user = user
            
            Match.fetchMatchUser(toUserId: self.toUserId) { (match) in
                self.matchUser = match
                
                if self.matchUser.isMatch == 1 {
                    self.nameLabel.text = "\(self.user.username!)"
                    self.matchLabel.text = "    マッチング済み✨"
                    self.nameLabel.isHidden = false
                    self.matchLabel.isHidden = false
                    
                } else {
                    self.nameLabel.text = "\(self.user.username!)"
                    self.nameLabel.isHidden = false
                    self.matchLabel.isHidden = true
                    self.nameLabelTopConstraint.constant = 60
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
        guard toUserId != "" else { return }
        Match.fetchMatchUser(toUserId: toUserId) { (match) in
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
        
        if textField.text!.count > 60 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "メッセージは60文字以下で入力してください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        let date: Double = Date().timeIntervalSince1970
        let dict = [MESSAGETEXT: textField.text!,
                    FROM: User.currentUserId(),
                    TO: toUserId,
                    TIMESTAMP: Timestamp(date: Date()),
                    DATE: date] as [String : Any]
        Message.saveMessage(to: user, withValue: dict)
        
        incrementAppBadgeCount()
        scrollToBottom()
        textField.text = ""
        sendButton.isEnabled = false
        sendButton.alpha = 0.7
        countLabel.text = "60"
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
        
        let messageNum = 60 - textField.text!.count
        if messageNum < 0 {
            countLabel.text = "×"
        } else {
            countLabel.text = String(messageNum)
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
            
            User.fetchUser(self.toUserId) { (user) in
                self.badgeUser = user
                
                sendRequestNotification(toUser: self.badgeUser, message: "\(self.currentUser.username!)さんからメッセージが届いています", badge: self.badgeUser.appBadgeCount + 1)
            }
        }
    }
    
    private func hintView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        backView.addGestureRecognizer(tap)
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil && UserDefaults.standard.object(forKey: HINT_END) == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.visualEffectView.frame = self.view.frame
                self.view.addSubview(self.visualEffectView)
                self.visualEffectView.alpha = 0
                self.view.addSubview(self.backView)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.visualEffectView.alpha = 1
                    self.backView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.backView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: HINT_END)
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        backView.alpha = 0
        visualEffectView.alpha = 0
        nameLabel.isHidden = true
        matchLabel.isHidden = true
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        sendButton.layer.cornerRadius = 5
        backView.layer.cornerRadius = 15
        
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
