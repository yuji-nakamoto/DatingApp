//
//  CommunityUsersTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/18.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class CommunityUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var backContentsImageView: UIImageView!
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var titlteLabel: UILabel!
    @IBOutlet weak var numberLabel1: UILabel!
    @IBOutlet weak var numberLabel2: UILabel!
    
    func configureCell(_ community: Community, _ user: User) {
        guard community.communityId != nil else { return }
        
        titlteLabel.text = community.title
        numberLabel1.text = String(community.allNumber) + "人"
        backContentsImageView.sd_setImage(with: URL(string: community.contentsImageUrl), completed: nil)
        contentsImageView.sd_setImage(with: URL(string: community.contentsImageUrl), completed: nil)
        
        if user.gender == "男性" {
            numberLabel2.text = "( 女性\(String(community.femaleNumber))人 )"
        } else {
            numberLabel2.text = "( 男性\(String(community.maleNumber))人 )"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        visualEffectView.frame = self.backContentsImageView.frame
        self.backContentsImageView.addSubview(visualEffectView)
        contentsImageView.layer.cornerRadius = 15
        titlteLabel.text = ""
        numberLabel1.text = ""
        numberLabel2.text = ""
    }
}
