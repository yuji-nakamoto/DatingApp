//
//  DidLikeTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DidLikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var mozaicView: UIView!
    @IBOutlet weak var blackLine1: UIView!
    @IBOutlet weak var blackLine2: UIView!
    
    var user = User()
    var inbox: Inbox!
    var inboxVC: InboxTableViewController?
    
    func configureCell(_ user: User) {
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        nameLabel.text = user.username
        residenceLabel.text = user.residence
        ageLabel.text = String(user.age) + "歳"
        
        COLLECTION_USERS.document(user.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.onlineView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
    }
    
    func configureCell2(_ user: User) {
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            onlineView.isHidden = true
            mozaicView.isHidden = false
            blackLine1.isHidden = false
            blackLine2.isHidden = false
            blackLine1.layer.cornerRadius = 16 / 2
            blackLine2.layer.cornerRadius = 16 / 2
            mozaicView.layer.cornerRadius = 70 / 2
            nameLabel.layer.shouldRasterize = true
            nameLabel.layer.rasterizationScale = 0.35
        } else {
            mozaicView.isHidden = true
        }
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        nameLabel.text = user.username
        residenceLabel.text = user.residence
        ageLabel.text = String(user.age) + "歳"
    }
    
    func configureCell3(_ user: User) {
        
        mozaicView.isHidden = true
        blackLine1.isHidden = true
        blackLine2.isHidden = true
        onlineView.isHidden = false
        profileImageView.layer.shouldRasterize = false
        nameLabel.layer.shouldRasterize = false
        
        profileImageView.layer.rasterizationScale = 1
        nameLabel.layer.rasterizationScale = 1
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        nameLabel.text = user.username
        residenceLabel.text = user.residence
        ageLabel.text = String(user.age) + "歳"
        
        COLLECTION_USERS.document(user.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.onlineView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
    }
    
    func configureCell4(_ user: User) {
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        nameLabel.text = user.username
        residenceLabel.text = user.residence
        ageLabel.text = String(user.age) + "歳"
    }
    
    func configureInboxCell(_ inbox: Inbox) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfileImage))
        profileImageView.addGestureRecognizer(tap)
        
        profileImageView.sd_setImage(with: URL(string: inbox.user.profileImageUrl1), completed: nil)
        nameLabel.text = inbox.user.username
        residenceLabel.text = inbox.user.residence
        ageLabel.text = String(inbox.user.age) + "歳"
        
        let date = Date(timeIntervalSince1970: inbox.message.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        timestampLabel.text = dateString
        
        COLLECTION_USERS.document(inbox.user.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.onlineView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
    }
    
    @objc func tapProfileImage() {
        if let uid = inbox.user.uid {
            inboxVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
        }
    }
    
    var footstep: Footstep? {
        didSet {
            let date = Date(timeIntervalSince1970: footstep!.date)
            let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            timestampLabel.text = dateString
        }
    }
    
    var like: Like? {
        didSet {
            timestampLabel.text = timestamp1
        }
    }
    
    var type: Type? {
        didSet {
            timestampLabel.text = timestamp2
        }
    }
    
    var block: Block? {
        didSet {
            timestampLabel.text = timestamp3
        }
    }
    
    var timestamp1: String {
        let date = like?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date!)
    }
    
    var timestamp2: String {
        let date = type?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date!)
    }
    
    var timestamp3: String {
        let date = block?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 70 / 2
        onlineView.layer.cornerRadius = 15 / 2
        onlineView.layer.borderWidth = 2
        onlineView.layer.borderColor = UIColor.white.cgColor
    }
    
}
