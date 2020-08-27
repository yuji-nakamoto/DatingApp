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
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var user = User()
    private var currentUser = User()
    private var badgeUser = User()
    private var matchUser = Match()
    private var users = [User]()
    private var messages = [Message]()
    private var message = Message()
    private var interstitial: GADInterstitial!
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var hud = JGProgressHUD(style: .dark)
    var toUserId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setupUI()
        fetchMatchUser()
        handleTextField()
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
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
        
        Message.fetchMessage(toUserId: user.uid) { (message) in
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
            self.checkMessage()
        }
    }
    
    private func checkFemale() {
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
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
        
        if matchUser.isMatch != 1 {
            if self.message.from == User.currentUserId() {
                if currentUser.usedItem1 > 0 {
                    let alert: UIAlertController = UIAlertController(title: "おかわり", message: "アイテムを使用してメッセージを送信します。送信しますか？", preferredStyle: .alert)
                    let exchange: UIAlertAction = UIAlertAction(title: "送信する", style: UIAlertAction.Style.default) { (alert) in
                        
                        self.hud.show(in: self.view)
                        self.hud.textLabel.text = "アイテムを使用しました。"
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.dismiss(afterDelay: 2.0)
                        updateUser(withValue: [USEDITEM1: self.currentUser.usedItem1 - 1])
                        
                        let date: Double = Date().timeIntervalSince1970
                        let dict = [MESSAGETEXT: self.textField.text!,
                                    FROM: User.currentUserId(),
                                    TO: self.toUserId,
                                    USEDITEM5: self.currentUser.usedItem5 as Any,
                                    TIMESTAMP: Timestamp(date: Date()),
                                    DATE: date] as [String : Any]
                        Message.saveMessage(to: self.user, withValue: dict)
                        
                        self.setupMessage()
                        return
                    }
                    let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
                    }
                    alert.addAction(exchange)
                    alert.addAction(cancel)
                    self.present(alert,animated: true,completion: nil)
                    return
                }
            }
        }
        
        let date: Double = Date().timeIntervalSince1970
        let dict = [MESSAGETEXT: textField.text!,
                    FROM: User.currentUserId(),
                    TO: toUserId,
                    USEDITEM5: self.currentUser.usedItem5 as Any,
                    TIMESTAMP: Timestamp(date: Date()),
                    DATE: date] as [String : Any]
        Message.saveMessage(to: user, withValue: dict)
        setupMessage()
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
    
    private func checkMessage() {
        
        if matchUser.isMatch == 1 {
            bottomView.isHidden = false
        } else {
            Message.fetchMessage(toUserId: toUserId) { (message) in
                self.message = message
                
                User.fetchUser (User.currentUserId()) { (user) in
                    
                    if self.message.from == User.currentUserId() {
                        
                        self.currentUser = user
                        if self.currentUser.usedItem1 > 0 {
                            self.bottomView.isHidden = false
                        } else {
                            self.bottomView.isHidden = true
                            self.showHintView()
                        }
                    }
                }
            }
        }
    }
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/4674347886")
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
    
    private func showHintView() {
        
        visualEffectView.frame = self.view.frame
        visualEffectView.alpha = 0
        view.addSubview(self.visualEffectView)
        view.addSubview(self.backView)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
            self.backView.alpha = 1
        }, completion: nil)
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
    
    private func setupMessage() {
        
        self.incrementAppBadgeCount()
        self.scrollToBottom()
        self.textField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.alpha = 0.7
        self.countLabel.text = "60"
        self.textField.resignFirstResponder()
        self.checkFemale()
        self.checkMessage()
    }
    
    private func setupBanner() {
        
        // test adUnitID
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
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
        closeButton.layer.cornerRadius = 40 / 2
        
        textField.delegate = self
        sendButton.isEnabled = false
        sendButton.alpha = 0.7
        navBar.alpha = 0.85
        hintLabel.text = "マッチすると2通目以降も送信ができます。\n\nもしくは、アイテムを使用することで送信ができます。"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            sendButton.backgroundColor = UIColor(named: O_PINK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            navBar.backgroundColor = UIColor(named: O_PINK)
            nameLabel.textColor = .white
            backButton.tintColor = .white
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            sendButton.backgroundColor = UIColor(named: O_GREEN)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            navBar.backgroundColor = UIColor(named: O_GREEN)
            nameLabel.textColor = .white
            backButton.tintColor = .white
            
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            sendButton.backgroundColor = UIColor(named: O_GREEN)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            navBar.backgroundColor = .white
            nameLabel.textColor = UIColor(named: O_BLACK)
            backButton.tintColor = UIColor(named: O_BLACK)
            
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            sendButton.backgroundColor = UIColor(named: O_DARK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
            navBar.backgroundColor = UIColor(named: O_DARK)
            nameLabel.textColor = .white
            backButton.tintColor = .white
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
