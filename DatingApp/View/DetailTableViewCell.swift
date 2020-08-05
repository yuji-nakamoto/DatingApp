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
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var profileImageView2: UIImageView!
    @IBOutlet weak var profileImageView3: UIImageView!
    @IBOutlet weak var segBarSingle: UIView!
    @IBOutlet weak var segBarDouble1: UIView!
    @IBOutlet weak var segBarDouble2: UIView!
    @IBOutlet weak var segBarTriple1: UIView!
    @IBOutlet weak var segBarTriple2: UIView!
    @IBOutlet weak var segBarTriple3: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var birthplaceLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var marriageHistoyLabel: UILabel!
    @IBOutlet weak var child1Label: UILabel!
    @IBOutlet weak var marriageLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    @IBOutlet weak var child2Label: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var liquorlabel: UILabel!
    @IBOutlet weak var housemateLabel: UILabel!
    @IBOutlet weak var tobaccoLabel: UILabel!
    
    // MARK: - Helpers
    
    var user: User!
    
    func configureCell(_ user: User?) {
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        profileImageView1.addGestureRecognizer(tap1)
        profileImageView2.addGestureRecognizer(tap2)
        profileImageView3.addGestureRecognizer(tap3)
        
        if user?.profileImageUrl1 != nil {
            profileImageView1.sd_setImage(with: URL(string: user!.profileImageUrl1), completed: nil)
            profileImageView2.sd_setImage(with: URL(string: user!.profileImageUrl2), completed: nil)
            profileImageView3.sd_setImage(with: URL(string: user!.profileImageUrl3), completed: nil)
        }
        profileImageView1.layer.cornerRadius = 15
        profileImageView2.layer.cornerRadius = 15
        profileImageView3.layer.cornerRadius = 15
        
        selfIntrolabel.text = user?.selfIntro
        nameLabel.text = user?.username
        nameLabel2.text = user?.username
        residenceLabel.text = user?.residence
        residenceLabel2.text = user?.residence
        professionLabel.text = user?.profession
        commentLabel.text = user?.comment
        bodyLabel.text = user?.bodySize
        heightLabel.text = user?.height
        
        if user!.age == nil {
            return
        }
        ageLabel.text = String(user!.age) + "歳"
        ageLabel2.text = String(user!.age) + "歳"
        bloodLabel.text = user?.blood
        birthplaceLabel.text = user?.birthplace
        educationLabel.text = user?.education
        marriageHistoyLabel.text = user?.marriageHistory
        marriageLabel.text = user?.marriage
        child1Label.text = user?.child1
        child2Label.text = user?.child2
        hobbyLabel.text = user?.hobby1
        housemateLabel.text = user?.houseMate
        holidayLabel.text = user?.holiday
        liquorlabel.text = user?.liquor
        tobaccoLabel.text = user?.tobacco
        
        if user?.hobby1 != "" && user?.hobby2 != "" && user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby2)! + ",\n" + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 13)
        } else if user?.hobby1 != "" && user?.hobby2 != "" {
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby2)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 15)
        } else if user?.hobby2 != "" && user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby2)! + "," + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 15)
        } else if user?.hobby1 != "" && user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 15)
        } else if user?.hobby1 != "" || user?.hobby2 != "" || user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby1)! + (user?.hobby2)! + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 17)
        } else {
            hobbyLabel.text = "未設定"
            hobbyLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        if timeLabel != nil {
            let date = user?.lastChanged.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd h:m"
            timeLabel.text = dateFormatter.string(from: date!)
        }
        
        if user!.profileImageUrl2 == "" && user!.profileImageUrl3 == "" {
            profileImageUrl23Nil()
        } else if user!.profileImageUrl3 == "" {
            profileImageUrl3Nil()
        } else {
            profileImageUrlHaveAll()
        }
    }
    
    @objc func handleChangePhoto(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            
            generator.notificationOccurred(.success)
            if user.profileImageUrl2 == "" && user.profileImageUrl3 == "" {
                return
            } else if user.profileImageUrl3 == "" {
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    segBarDouble1.alpha = 0.5
                    segBarDouble2.alpha = 1
                } else if profileImageView1.isHidden == true {
                    return
                }
            } else {
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    segBarTriple1.alpha = 0.5
                    segBarTriple2.alpha = 1
                } else if profileImageView1.isHidden == true {
                    segBarTriple1.alpha = 0.5
                    segBarTriple2.alpha = 0.5
                    segBarTriple3.alpha = 1
                    profileImageView2.isHidden = true
                } else if profileImageView2.isHidden == true {
                    return
                }
            }
        } else {
            generator.notificationOccurred(.success)
            if user.profileImageUrl3 == "" {
                segBarDouble1.alpha = 1
                segBarDouble2.alpha = 0.5
            } else {
                if profileImageView2.isHidden == true {
                    profileImageView2.isHidden = false
                    segBarTriple2.alpha = 1
                    segBarTriple3.alpha = 0.5
                    return
                } else if profileImageView1.isHidden == true {
                    profileImageView1.isHidden = false
                    segBarTriple1.alpha = 1
                    segBarTriple2.alpha = 0.5
                    return
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true {
                    profileImageView2.isHidden = false
                    segBarTriple2.alpha = 1
                    segBarTriple3.alpha = 0.5
                    return
                }
            }
            if profileImageView2.isHidden == true {
                profileImageView2.isHidden = false
            } else if profileImageView1.isHidden == true {
                profileImageView1.isHidden = false
            } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true {
                profileImageView2.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ageLabel.text = ""
        segBarSingle.layer.cornerRadius = 5 / 2
        segBarDouble1.layer.cornerRadius = 5 / 2
        segBarDouble2.layer.cornerRadius = 5 / 2
        segBarTriple1.layer.cornerRadius = 5 / 2
        segBarTriple2.layer.cornerRadius = 5 / 2
        segBarTriple3.layer.cornerRadius = 5 / 2
    }
    
    func profileImageUrl23Nil() {
        segBarDouble1.isHidden = true
        segBarDouble2.isHidden = true
        segBarTriple1.isHidden = true
        segBarTriple2.isHidden = true
        segBarTriple3.isHidden = true
    }
    
    func profileImageUrl3Nil() {
        segBarSingle.isHidden = true
        segBarDouble1.isHidden = false
        segBarDouble2.isHidden = false
        segBarTriple1.isHidden = true
        segBarTriple2.isHidden = true
        segBarTriple3.isHidden = true
        segBarDouble2.alpha = 0.5
    }
    
    func profileImageUrlHaveAll() {
        segBarSingle.isHidden = true
        segBarDouble1.isHidden = true
        segBarDouble2.isHidden = true
        segBarTriple1.isHidden = false
        segBarTriple2.isHidden = false
        segBarTriple3.isHidden = false
        segBarTriple2.alpha = 0.5
        segBarTriple3.alpha = 0.5
    }
    
}
