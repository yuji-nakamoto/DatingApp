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
    
    
    func configureCell(_ like: Like) {
        
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.sd_setImage(with: URL(string: like.profileImageUrl), completed: nil)
        nameLabel.text = like.name
        residenceLabel.text = like.residence
        ageLabel.text = like.age
    }
    
    func configureCell(_ superLike: SuperLike) {
        
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.sd_setImage(with: URL(string: superLike.profileImageUrl), completed: nil)
        nameLabel.text = superLike.name
        residenceLabel.text = superLike.residence
        ageLabel.text = superLike.age
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
