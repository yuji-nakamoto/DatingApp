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
            
    // MARK: - Helpers
    
    func configureCell(_ user: User) {
        
        nameLabel.text = user.username
        nameLabel2.text = user.username
        residenceLabel.text = user.residence
        residenceLabel2.text = user.residence
        ageLabel.text = user.age
        ageLabel2.text = user.age
        selfIntrolabel.text = user.selfIntro
        professionLabel.text = user.profession
    }

}
