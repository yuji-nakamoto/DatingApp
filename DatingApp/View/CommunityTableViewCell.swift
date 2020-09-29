//
//  CommunityTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/17.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class CommunityTableViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    func configureCell(_ community: Community) {
        
        titleLabel.text = community.title
        numberLabel.text = String(community.allNumber) + "人"
        contentsImageView.sd_setImage(with: URL(string: community.contentsImageUrl), completed: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentsImageView.layer.cornerRadius = 15
    }
}
