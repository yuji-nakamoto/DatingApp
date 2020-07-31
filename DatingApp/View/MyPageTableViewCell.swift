//
//  MyPageTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    func configureCell(_ user: User?) {
        
        if user != nil {
            profileImageView.sd_setImage(with: URL(string: user!.profileImageUrl1), completed: nil)
            nameLabel.text = user!.username
            
            if UserDefaults.standard.object(forKey: FEMALE) != nil {
                profileButton.backgroundColor = UIColor(named: O_PINK)
                profileButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                profileButton.backgroundColor = UIColor(named: O_GREEN)
                profileButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        profileButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 100 / 2
        
        
    }

}
