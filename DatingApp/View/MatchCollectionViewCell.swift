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
    @IBOutlet weak var onlineView: UIView!
    
    func configureCell(_ user: User) {
 
        contentView.layer.cornerRadius = 10
        shadowView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = 10
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        residenceLabel.text = user.residence
        ageLabel.text = String(user.age) + "歳"
        nameLabel.text = user.username
    }
    
    func configureDateCell(_ match: Match) {
        let date = Date(timeIntervalSince1970: match.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        timeLabel.text = dateString
    }
    
    func configureMacthCell(_ user: User) {
        
        profileImageView.layer.cornerRadius = 60 / 2
        onlineView.layer.cornerRadius = 15 / 2
        onlineView.layer.borderWidth = 2
        onlineView.layer.borderColor = UIColor.white.cgColor
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        
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
}
