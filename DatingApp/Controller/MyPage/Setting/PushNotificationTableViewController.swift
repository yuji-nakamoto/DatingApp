//
//  PushNotificationTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/06.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class PushNotificationTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var likeSwitch: UISwitch!
    @IBOutlet weak var typeSwitch: UISwitch!
    @IBOutlet weak var messageSwitch: UISwitch!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var matchSwitch: UISwitch!
    @IBOutlet weak var giftSwitch: UISwitch!
    @IBOutlet weak var giftLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var replySwitch: UISwitch!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentSwitch: UISwitch!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK:- Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func replySwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: REPLY_ON)
            Messaging.messaging().subscribe(toTopic: "reply\(Auth.auth().currentUser!.uid)")
            replyLabel.text = "リプライ通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: GIFT_ON)
            Messaging.messaging().unsubscribe(fromTopic: "reply\(Auth.auth().currentUser!.uid)")
            replyLabel.text = "リプライ通知を受信しない"
        }
    }
    
    @IBAction func giftSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: GIFT_ON)
            Messaging.messaging().subscribe(toTopic: "gift\(Auth.auth().currentUser!.uid)")
            giftLabel.text = "プレゼント通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: GIFT_ON)
            Messaging.messaging().unsubscribe(fromTopic: "gift\(Auth.auth().currentUser!.uid)")
            giftLabel.text = "プレゼント通知を受信しない"
        }
    }
    
    @IBAction func likeSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: LIKE_ON)
            Messaging.messaging().subscribe(toTopic: "like\(Auth.auth().currentUser!.uid)")
            likeLabel.text = "いいね通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: LIKE_ON)
            Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
            likeLabel.text = "いいね通知を受信しない"
        }
    }
    
    @IBAction func typeSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: TYPE_ON)
            Messaging.messaging().subscribe(toTopic: "type\(Auth.auth().currentUser!.uid)")
            typeLabel.text = "タイプ通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: TYPE_ON)
            Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
            typeLabel.text = "タイプ通知を受信しない"
        }
    }
    
    @IBAction func messageSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: MESSAGE_ON)
            Messaging.messaging().subscribe(toTopic: "message\(Auth.auth().currentUser!.uid)")
            messageLabel.text = "メッセージ通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: MESSAGE_ON)
            Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
            messageLabel.text = "メッセージ通知を受信しない"
        }
    }
    
    @IBAction func matchSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: MATCH_ON)
            Messaging.messaging().subscribe(toTopic: "match\(Auth.auth().currentUser!.uid)")
            matchLabel.text = "マッチング通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: MATCH_ON)
            Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")
            matchLabel.text = "マッチング通知を受信しない"
        }
    }
    
    @IBAction func commnentSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: COMMENT_ON)
            Messaging.messaging().subscribe(toTopic: "comment\(Auth.auth().currentUser!.uid)")
            commentLabel.text = "コメント通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: COMMENT_ON)
            Messaging.messaging().unsubscribe(fromTopic: "comment\(Auth.auth().currentUser!.uid)")
            commentLabel.text = "コメント通知を受信しない"
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        navigationItem.title = "プッシュ通知設定"
        tableView.tableFooterView = UIView()
        
        if UserDefaults.standard.object(forKey: LIKE_ON) != nil {
            likeSwitch.isOn = true
            likeLabel.text = "いいね通知を受信する"
        } else {
            likeSwitch.isOn = false
            likeLabel.text = "いいね通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: TYPE_ON) != nil {
            typeSwitch.isOn = true
            typeLabel.text = "タイプ通知を受信する"
        } else {
            typeSwitch.isOn = false
            typeLabel.text = "タイプ通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: MESSAGE_ON) != nil {
            messageSwitch.isOn = true
            messageLabel.text = "メッセージ通知を受信する"
        } else {
            messageSwitch.isOn = false
            messageLabel.text = "メッセージ通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: MATCH_ON) != nil {
            matchSwitch.isOn = true
            matchLabel.text = "マッチング通知を受信する"
        } else {
            matchSwitch.isOn = false
            matchLabel.text = "マッチング通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: GIFT_ON) != nil {
            giftSwitch.isOn = true
            giftLabel.text = "プレゼント通知を受信する"
        } else {
            giftSwitch.isOn = false
            giftLabel.text = "プレゼント通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: REPLY_ON) != nil {
            replySwitch.isOn = true
            replyLabel.text = "リプライ通知を受信する"
        } else {
            replySwitch.isOn = false
            replyLabel.text = "リプライ通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: COMMENT_ON) != nil {
            commentSwitch.isOn = true
            commentLabel.text = "コメント通知を受信する"
        } else {
            commentSwitch.isOn = false
            commentLabel.text = "コメント通知を受信しない"
        }
    }
}
