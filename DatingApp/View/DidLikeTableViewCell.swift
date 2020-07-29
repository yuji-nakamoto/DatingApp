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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func configureCell(_ user: User) {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            backView.backgroundColor = UIColor(named: O_GREEN)
        } else {
            backView.backgroundColor = UIColor(named: O_PINK)
        }
        backView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = 10
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        nameLabel.text = user.username
        residenceLabel.text = user.residence
        ageLabel.text = user.age
        selfIntroLabel.text = user.selfIntro
    }

    var footstep: Footstep? {
        didSet {
            timestampLabel.text = timestamp1
        }
    }
    
    var like: Like? {
        didSet {
            timestampLabel.text = timestamp2
        }
    }
    
    var type: Type? {
        didSet {
            timestampLabel.text = timestamp3
        }
    }
    
    var timestamp1: String {
        let date = footstep?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: date!)
    }
    
    var timestamp2: String {
        let date = like?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: date!)
    }
    
    var timestamp3: String {
        let date = type?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日"
        return dateFormatter.string(from: date!)
    }
    
}
