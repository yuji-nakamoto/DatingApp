//
//  DetailTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var selfIntrolabel: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var ageLabel2: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var residenceLabel2: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    // MARK: - Helpers
    
    func configureCell(_ user: User?) {
        
        selfIntrolabel.text = user!.selfIntro
        nameLabel.text = user!.username
        nameLabel2.text = user!.username
        residenceLabel.text = user!.residence
        residenceLabel2.text = user!.residence
        professionLabel.text = user!.profession
        commentLabel.text = user!.comment
        bodyLabel.text = user!.bodySize
        heightLabel.text = user!.height
        if user!.age == nil {
            return
        }
        ageLabel.text = String(user!.age) + "歳"
        ageLabel2.text = String(user!.age) + "歳"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = ""
        nameLabel2.text = ""
        residenceLabel.text = ""
        residenceLabel2.text = ""
        ageLabel.text = ""
        ageLabel2.text = ""
        selfIntrolabel.text = ""
        professionLabel.text = ""
        commentLabel.text = ""
        bodyLabel.text = ""
        heightLabel.text = ""
    }

}
