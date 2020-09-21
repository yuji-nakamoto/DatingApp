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
    @IBOutlet weak var numberLabel: UILabel!
        
    func configureCell(_ community: Community) {
        guard community.communityId != nil else { return }
        titlteLabel.text = community.title
        numberLabel.text = String(community.number) + "人"
        backContentsImageView.sd_setImage(with: URL(string: community.contentsImageUrl), completed: nil)
        contentsImageView.sd_setImage(with: URL(string: community.contentsImageUrl), completed: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)

        visualEffectView.frame = self.backContentsImageView.frame
        self.backContentsImageView.addSubview(visualEffectView)
        contentsImageView.layer.cornerRadius = 15
        titlteLabel.text = ""
        numberLabel.text = ""
    }
}
