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
    @IBOutlet weak var cogImageView: UIImageView!
    
    func configureCell(_ user: User?) {
        
        if user?.uid != nil {
            profileImageView.sd_setImage(with: URL(string: user!.profileImageUrl1), completed: nil)
            nameLabel.text = user!.username
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        redmark.layer.cornerRadius = 4
        nameLabel.text = ""
        profileButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 100 / 2
    }
    
    func cogAnimation() {
        let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rollingAnimation.fromValue = 0
        rollingAnimation.toValue = CGFloat.pi * 0.2
        rollingAnimation.duration = 0.3
        rollingAnimation.repeatDuration = CFTimeInterval.zero
        cogImageView.layer.add(rollingAnimation, forKey: "rollingImage")
    }
}
