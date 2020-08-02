//
//  SearchCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    // MARK: - Helpers
    
    func configureCell(_ user: User) {
        
        profileImageView.layer.cornerRadius = 150 / 2
        statusView.layer.cornerRadius = 30 / 2
        statusView.layer.borderWidth = 4
        statusView.layer.borderColor = UIColor.white.cgColor
        
        ageLabel.text = String(user.age) + "歳"
        residenceLabel.text = user.residence
        selfIntroLabel.text = user.selfIntro
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        
        COLLECTION_USERS.document(user.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.statusView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
        
    }

}
