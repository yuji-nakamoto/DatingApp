//
//  MatchCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/06.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(_ user: User) {
 
        contentView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = 10
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        residenceLabel.text = user.residence
        ageLabel.text = String(user.age) + "歳"
        nameLabel.text = user.username
        
        let date = user.lastChanged.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd h:m"
        timeLabel.text = dateFormatter.string(from: date)
    }
}