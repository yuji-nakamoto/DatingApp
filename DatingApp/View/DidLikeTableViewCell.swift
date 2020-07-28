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
    
}
