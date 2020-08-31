//
//  MessageTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bubleLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubleRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var readLabel: UILabel!
    
    var message: Message? {
        didSet {
            updateView()
        }
    }
        
    func updateView() {
        let text = message!.messageText
        let widthValue = text!.estimateFrameForText(text!).width + 40
        
        messageLabel.isHidden = false
        messageLabel.text = message!.messageText
        dateLabel.textColor = .white
        readLabel.isHidden = false
        
        if widthValue < 100 {
            bubleWidthConstraint.constant = 100
        } else {
            bubleWidthConstraint.constant = widthValue
        }
        
        if User.currentUserId() == message!.from {
            
            if UserDefaults.standard.object(forKey: PINK) != nil {
                bubleView.backgroundColor = UIColor(named: O_PINK)
                messageLabel.textColor = UIColor.white

            } else if UserDefaults.standard.object(forKey: GREEN) != nil {
                bubleView.backgroundColor = UIColor(named: O_GREEN)
                messageLabel.textColor = UIColor.white

            } else if UserDefaults.standard.object(forKey: WHITE) != nil {
                bubleView.backgroundColor = UIColor(named: O_GREEN)
                
            } else if UserDefaults.standard.object(forKey: DARK) != nil {
                bubleView.backgroundColor = UIColor(named: O_DARK)
                messageLabel.textColor = UIColor.white
            }
            
            if UserDefaults.standard.object(forKey: ISREAD_ON) != nil {
                readLabel.isHidden = false
            } else {
                readLabel.isHidden = true
            }
            
            if message?.isRead == true {
                readLabel.text = "既読"
            } else {
                readLabel.text = "未読"
            }
            
            bubleView.layer.borderColor = UIColor.clear.cgColor
            bubleRightConstraint.constant = 8
            bubleLeftConstraint.constant = UIScreen.main.bounds.width - bubleWidthConstraint.constant - bubleRightConstraint.constant
        } else {
            
            readLabel.isHidden = true
            messageLabel.textColor = UIColor.black
            profileImageView.isHidden = false
            bubleView.backgroundColor = UIColor.systemGray3
            bubleView.layer.borderColor = UIColor.clear.cgColor
            bubleLeftConstraint.constant = 55
            bubleRightConstraint.constant = UIScreen.main.bounds.width - bubleWidthConstraint.constant - bubleLeftConstraint.constant
        }
        
        let date = Date(timeIntervalSince1970: message!.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = dateString
        self.formatHeaderTimeLabel(time: date) { (text) in
            self.timeLabel.text = text
        }
    }
    
    func formatHeaderTimeLabel(time: Date, comletion: @escaping (String) -> ()) {
        var text = ""
        let currentDate = Date()
        let currentDateString = currentDate.toString(dateFormat: "yyyymmdd")
        let pastDateString = time.toString(dateFormat: "yyyymmdd")
        
        if pastDateString.elementsEqual(currentDateString) == true {
            text = time.toString(dateFormat: "HH:mm a") + ", 今日"
        } else {
            text = time.toString(dateFormat: "MM/dd/yyyy")
        }
        comletion(text)
    }
    
    func configureUser(_ user: User) {
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 36 / 2
        profileImageView.isHidden = true
        bubleView.layer.cornerRadius = 15
        bubleView.layer.borderWidth = 1
        timeLabel.text = ""
        dateLabel.text = ""
        messageLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.isHidden = true
    }
}
