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
    @IBOutlet weak var redmark: UIView!
    
    
    func configureCell(_ user: User?) {
        
        if user?.uid != nil {
            profileImageView.sd_setImage(with: URL(string: user!.profileImageUrl1), completed: nil)
            nameLabel.text = user!.username
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        redmark.layer.cornerRadius = 5
        nameLabel.text = ""
        profileButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 100 / 2
    }

}
