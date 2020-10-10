//
//  DetailTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

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
    @IBOutlet weak var profileImageView4: UIImageView!
    @IBOutlet weak var profileImageView5: UIImageView!
    @IBOutlet weak var profileImageView6: UIImageView!
    @IBOutlet weak var segBarDouble1: UIView!
    @IBOutlet weak var segBarDouble2: UIView!
    @IBOutlet weak var segBarTriple1: UIView!
    @IBOutlet weak var segBarTriple2: UIView!
    @IBOutlet weak var segBarTriple3: UIView!
    @IBOutlet weak var segBarFour1: UIView!
    @IBOutlet weak var segBarFour2: UIView!
    @IBOutlet weak var segBarFour3: UIView!
    @IBOutlet weak var segBarFour4: UIView!
    @IBOutlet weak var segBarFive1: UIView!
    @IBOutlet weak var segBarFive2: UIView!
    @IBOutlet weak var segBarFive3: UIView!
    @IBOutlet weak var segBarFive4: UIView!
    @IBOutlet weak var segBarFive5: UIView!
    @IBOutlet weak var segBarSix1: UIView!
    @IBOutlet weak var segBarSix2: UIView!
    @IBOutlet weak var segBarSix3: UIView!
    @IBOutlet weak var segBarSix4: UIView!
    @IBOutlet weak var segBarSix5: UIView!
    @IBOutlet weak var segBarSix6: UIView!
    @IBOutlet weak var stackViewDouble: UIStackView!
    @IBOutlet weak var stackViewTriple: UIStackView!
    @IBOutlet weak var stackViewFour: UIStackView!
    @IBOutlet weak var stackViewFive: UIStackView!
    @IBOutlet weak var stackViewSix: UIStackView!
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
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var typeCountLabel: UILabel!
    @IBOutlet weak var loginBottomConstrait: NSLayoutConstraint!
    @IBOutlet weak var AgeLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailMapLabel: UILabel!
    @IBOutlet weak var visitedLabel: UILabel!
    @IBOutlet weak var iconEye: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var hobbyLbl1: UILabel!
    @IBOutlet weak var hobbyLbl2: UILabel!
    @IBOutlet weak var hobbyLbl3: UILabel!
    @IBOutlet weak var communityImageView1: UIImageView!
    @IBOutlet weak var communityImageView2: UIImageView!
    @IBOutlet weak var communityImageView3: UIImageView!
    @IBOutlet weak var communityLabel1: UILabel!
    @IBOutlet weak var communityLabel2: UILabel!
    @IBOutlet weak var communityLabel3: UILabel!
    @IBOutlet weak var numberLabel1: UILabel!
    @IBOutlet weak var numberLabel2: UILabel!
    @IBOutlet weak var numberLabel3: UILabel!
    @IBOutlet weak var crown: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    // MARK: - User
    
    var user = User()
    var currentUser = User()
    var profileVC: ProfileTableViewController?
    var detailVC: DetailTableViewController?
    
    func configureCell(_ user: User?) {
        
        if user?.mMissionClear == true {
            crown.isHidden = false
        } else {
            crown.isHidden = true
        }
        
        if user?.profileImageUrl2 == "" {
            loginBottomConstrait.constant = -10
            AgeLabelBottomConstraint.constant = -10
        } else {
            loginBottomConstrait.constant = 10
            AgeLabelBottomConstraint.constant = 10
        }
        
        if user?.uid != nil {
            getLikeCount(ref: COLLECTION_LIKECOUNTER.document((user?.uid)!))
            getTypeCount(ref: COLLECTION_TYPECOUNTER.document((user?.uid)!))
        }
        
        if user?.visited == nil {
            return
        }
        if (user?.visited)! > 999 {
            visitedLabel.text = "999"
        } else {
            visitedLabel.text = String(user!.visited)
        }
        
        if user?.uid == User.currentUserId() {
            iconEye.image = UIImage(systemName: "eye.slash.fill")
            visitedLabel.isHidden = true
            if user?.usedItem6 == 1 {
                iconEye.image = UIImage(systemName: "eye.fill")
                visitedLabel.isHidden = false
            }
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        let tap6 = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        profileImageView1.addGestureRecognizer(tap1)
        profileImageView2.addGestureRecognizer(tap2)
        profileImageView3.addGestureRecognizer(tap3)
        profileImageView4.addGestureRecognizer(tap4)
        profileImageView5.addGestureRecognizer(tap5)
        profileImageView6.addGestureRecognizer(tap6)
        
        if user?.profileImageUrl1 != nil {
            profileImageView1.sd_setImage(with: URL(string: user!.profileImageUrl1), completed: nil)
            profileImageView2.sd_setImage(with: URL(string: user!.profileImageUrl2), completed: nil)
            profileImageView3.sd_setImage(with: URL(string: user!.profileImageUrl3), completed: nil)
            profileImageView4.sd_setImage(with: URL(string: user!.profileImageUrl4), completed: nil)
            profileImageView5.sd_setImage(with: URL(string: user!.profileImageUrl5), completed: nil)
            profileImageView6.sd_setImage(with: URL(string: user!.profileImageUrl6), completed: nil)
        }
        
        nameLabel.text = user?.username
        nameLabel2.text = user?.username
        residenceLabel.text = user?.residence
        residenceLabel2.text = user?.residence
        userIdLabel.text = user?.uid
        
        if currentUser.administrator != true {
            userIdLabel.isHidden = true
            idLabel.isHidden = true
        }
        
        if user?.profession == "" {
            professionLabel.text = "未設定"
        } else {
            professionLabel.text = user?.profession
        }
        
        if user?.bodySize == "" {
            bodyLabel.text = "未設定"
        } else {
            bodyLabel.text = user?.bodySize
        }
        
        if user!.height <= 129 {
            heightLabel.text = "未設定"
        } else {
            heightLabel.text = String(user!.height) + "cm"
        }
        
        if user?.selfIntro == "" {
            selfIntrolabel.text = "未入力"
        } else {
            selfIntrolabel.text = user?.selfIntro
        }
        
        if user?.comment == "" {
            commentLabel.text = "まだひとことはありません"
            commentLabel.textColor = .systemGray
        } else {
            commentLabel.text = user?.comment
            commentLabel.textColor = UIColor(named: O_BLACK)
        }
        
        if user?.detailArea == "" {
            detailMapLabel.text = "未設定"
        } else {
            detailMapLabel.text = user?.detailArea
        }
        
        if user?.age == nil { return }
        ageLabel.text = String(user!.age) + "歳"
        ageLabel2.text = String(user!.age) + "歳"
        
        if user?.blood == "" {
            bloodLabel.text = "未設定"
        } else {
            bloodLabel.text = user?.blood
        }
        
        if user?.birthplace == "" {
            birthplaceLabel.text = "未設定"
        } else {
            birthplaceLabel.text = user?.birthplace
        }
        
        if user?.education == "" {
            educationLabel.text = "未設定"
        } else {
            educationLabel.text = user?.education
        }
        
        if user?.marriageHistory == "" {
            marriageHistoyLabel.text = "未設定"
        } else {
            marriageHistoyLabel.text = user?.marriageHistory
        }
        
        if user?.marriage == "" {
            marriageLabel.text = "未設定"
        } else {
            marriageLabel.text = user?.marriage
        }
        
        if user?.child1 == "" {
            child1Label.text = "未設定"
        } else {
            child1Label.text = user?.child1
        }
        
        if user?.child2 == "" {
            child2Label.text = "未設定"
        } else {
            child2Label.text = user?.child2
        }
        
        if user?.houseMate == "" {
            housemateLabel.text = "未設定"
        } else {
            housemateLabel.text = user?.houseMate
        }
        
        if user?.holiday == "" {
            holidayLabel.text = "未設定"
        } else {
            holidayLabel.text = user?.holiday
        }
        
        if user?.liquor == "" {
            liquorlabel.text = "未設定"
        } else {
            liquorlabel.text = user?.liquor
        }
        
        if user?.tobacco == "" {
            tobaccoLabel.text = "未設定"
        } else {
            tobaccoLabel.text = user?.tobacco
        }
        
        if user?.hobby1 != "" && user?.hobby2 != "" && user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby2)! + "," + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 12)
            hobbyLbl1.text = "  \(user?.hobby1 ?? "")  "
            hobbyLbl2.text = "  \(user?.hobby2 ?? "")  "
            hobbyLbl3.text = "  \(user?.hobby3 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = false
            hobbyLbl3.isHidden = false
            
        } else if user?.hobby1 != "" && user?.hobby2 != "" {
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby2)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 15)
            hobbyLbl1.text = "  \(user?.hobby1 ?? "")  "
            hobbyLbl2.text = "  \(user?.hobby2 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = false
            hobbyLbl3.isHidden = true
            
        } else if user?.hobby2 != "" && user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby2)! + "," + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 15)
            hobbyLbl1.text = "  \(user?.hobby2 ?? "")  "
            hobbyLbl2.text = "  \(user?.hobby3 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = false
            hobbyLbl3.isHidden = true
            
        } else if user?.hobby1 != "" && user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 15)
            hobbyLbl1.text = "  \(user?.hobby1 ?? "")  "
            hobbyLbl2.text = "  \(user?.hobby3 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = false
            hobbyLbl3.isHidden = true
            
        } else if user?.hobby1 != "" {
            hobbyLabel.text = (user?.hobby1)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 17)
            hobbyLbl1.text = "  \(user?.hobby1 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = true
            hobbyLbl3.isHidden = true
            
        } else if user?.hobby2 != "" {
            hobbyLabel.text = (user?.hobby2)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 17)
            hobbyLbl1.text = "  \(user?.hobby2 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = true
            hobbyLbl3.isHidden = true
            
        } else if user?.hobby3 != "" {
            hobbyLabel.text = (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 17)
            hobbyLbl1.text = "  \(user?.hobby3 ?? "")  "
            hobbyLbl1.isHidden = false
            hobbyLbl2.isHidden = true
            hobbyLbl3.isHidden = true
            
        } else {
            hobbyLabel.text = "未設定"
            hobbyLabel.font = UIFont.systemFont(ofSize: 17)
            hobbyLbl1.isHidden = true
            hobbyLbl2.isHidden = true
            hobbyLbl3.isHidden = true
        }
        
        if timeLabel != nil {
            let date = user?.lastChanged.dateValue()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd h:m"
            timeLabel.text = dateFormatter.string(from: date!)
        }
        
        if user!.profileImageUrl2 == "" && user!.profileImageUrl3 == "" && user!.profileImageUrl4 == "" && user!.profileImageUrl5 == "" && user!.profileImageUrl6 == "" {
            profileImageUrl_23456Nil()
            
        } else if user!.profileImageUrl3 == "" && user!.profileImageUrl4 == "" && user!.profileImageUrl5 == "" && user!.profileImageUrl6 == "" {
            profileImageUrl_3456Nil()
            
        } else if user!.profileImageUrl4 == "" && user!.profileImageUrl5 == "" && user!.profileImageUrl6 == "" {
            profileImageUrl_456Nil()
            
        } else if user!.profileImageUrl5 == "" && user!.profileImageUrl6 == "" {
            profileImageUrl_56Nil()
            
        } else if user!.profileImageUrl6 == "" {
            profileImageUrl_6Nil()
            
        } else {
            profileImageUrlHaveAll()
        }
        
        COLLECTION_USERS.document((user?.uid)!).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.statusView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
    }
    
    // MARK: - Community
    
    func configureCommunity1(_ user: User, _ community1: Community) {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapCommunityLbl1))
        
        if user.community1 == "" {
            self.communityLabel1.isUserInteractionEnabled = false
            self.communityLabel1.textColor = UIColor(named: O_BLACK)
            self.communityLabel1.text = "参加していません"
            self.numberLabel1.isHidden = true
        } else {
            self.communityLabel1.isUserInteractionEnabled = true
            self.communityLabel1.textColor = UIColor(named: O_GREEN)
            self.communityLabel1.addGestureRecognizer(tap1)
            self.communityLabel1.text = community1.title
            self.numberLabel1.isHidden = false
            if community1.allNumber == nil { return }
            self.numberLabel1.text = String(community1.allNumber) + "人"
            self.communityImageView1.sd_setImage(with: URL(string: community1.contentsImageUrl), completed: nil)
        }
    }
    
    func configureCommunity2(_ user: User, _ community2: Community) {
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapCommunityLbl2))
        
        if user.community2 == "" {
            self.communityLabel2.isUserInteractionEnabled = false
            self.communityLabel2.textColor = UIColor(named: O_BLACK)
            self.communityLabel2.text = "参加していません"
            self.numberLabel2.isHidden = true
        } else {
            self.communityLabel2.isUserInteractionEnabled = true
            self.communityLabel2.textColor = UIColor(named: O_GREEN)
            self.communityLabel2.addGestureRecognizer(tap2)
            self.communityLabel2.text = community2.title
            self.numberLabel2.isHidden = false
            if community2.allNumber == nil { return }
            self.numberLabel2.text = String(community2.allNumber) + "人"
            self.communityImageView2.sd_setImage(with: URL(string: community2.contentsImageUrl), completed: nil)
        }
    }
    
    func configureCommunity3(_ user: User, _ community3: Community) {
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapCommunityLbl3))
        
        if user.community3 == "" {
            self.communityLabel3.isUserInteractionEnabled = false
            self.communityLabel3.textColor = UIColor(named: O_BLACK)
            self.communityLabel3.text = "参加していません"
            self.numberLabel3.isHidden = true
        } else {
            self.communityLabel3.isUserInteractionEnabled = true
            self.communityLabel3.textColor = UIColor(named: O_GREEN)
            self.communityLabel3.addGestureRecognizer(tap3)
            self.communityLabel3.text = community3.title
            self.numberLabel3.isHidden = false
            if community3.allNumber == nil { return }
            self.numberLabel3.text = String(community3.allNumber) + "人"
            self.communityImageView3.sd_setImage(with: URL(string: community3.contentsImageUrl), completed: nil)
        }
    }
    
    // MARK: - Location
    
    func currentLocation(_ user: User, _ currentLocation: CLLocation?) {
        
        guard let _ = currentLocation else { return }
        
        if user.latitude != "" && user.longitude != "" {
            let userLocation = CLLocation(latitude: Double(user.latitude)!, longitude: Double(user.longitude)!)
            let distanceInKM: CLLocationDistance = userLocation.distance(from: currentLocation!) / 1000
            
            if UserDefaults.standard.object(forKey: DISTANCE_ON) != nil {
                self.distanceLabel.text = String(format: "%.f Km", distanceInKM)
                self.distanceLabel.isHidden = false
            } else {
                self.distanceLabel.isHidden = true
            }
            
        } else {
            distanceLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc func tapCommunityLbl1() {
        
        if let communityId1 = user.community1 {
            profileVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: communityId1)
            detailVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: communityId1)
        }
    }
    
    @objc func tapCommunityLbl2() {
        
        if let communityId2 = user.community2 {
            profileVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: communityId2)
            detailVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: communityId2)
        }
    }
    
    @objc func tapCommunityLbl3() {
        
        if let communityId3 = user.community3 {
            profileVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: communityId3)
            detailVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: communityId3)
        }
    }
    
    @objc func handleChangePhoto(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            
            generator.notificationOccurred(.success)
            if user.profileImageUrl2 == "" && user.profileImageUrl3 == "" && user.profileImageUrl4 == "" && user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                return
                // seg 2 →
            } else if user.profileImageUrl3 == "" && user.profileImageUrl4 == "" && user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    profileImageView2.isHidden = false
                    segBarDouble1.alpha = 0.5
                    segBarDouble2.alpha = 1
                } else if profileImageView1.isHidden == true {
                    return
                }
                // seg 3 →
            } else if user.profileImageUrl4 == "" && user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    profileImageView2.isHidden = false
                    segBarTriple1.alpha = 0.5
                    segBarTriple2.alpha = 1
                } else if profileImageView1.isHidden == true {
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                    segBarTriple1.alpha = 0.5
                    segBarTriple2.alpha = 0.5
                    segBarTriple3.alpha = 1
                } else if profileImageView2.isHidden == true {
                    return
                }
                // seg 4 →
            } else if user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = true
                    segBarFour1.alpha = 0.5
                    segBarFour2.alpha = 1
                } else if profileImageView3.isHidden == true && profileImageView4.isHidden == false {
                    return
                } else if profileImageView1.isHidden == true && profileImageView3.isHidden == true {
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                    segBarFour2.alpha = 0.5
                    segBarFour3.alpha = 1
                } else if profileImageView2.isHidden == true && profileImageView4.isHidden == true {
                    segBarFour3.alpha = 0.5
                    segBarFour4.alpha = 1
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = false
                } else if profileImageView2.isHidden == true {
                    segBarFour3.alpha = 0.5
                    segBarFour4.alpha = 1
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = false
                } else if profileImageView1.isHidden == true {
                    segBarFour2.alpha = 0.5
                    segBarFour3.alpha = 1
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                }
                
                //seg 5 →
            } else if user.profileImageUrl6 == "" {
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = true
                    profileImageView5.isHidden = true
                    segBarFive1.alpha = 0.5
                    segBarFive2.alpha = 1
                } else if profileImageView4.isHidden == true && profileImageView5.isHidden == false {
                    return
                } else if profileImageView2.isHidden == true && profileImageView4.isHidden == true {
                    segBarFive3.alpha = 0.5
                    segBarFive4.alpha = 1
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = false
                } else if profileImageView2.isHidden == true && profileImageView3.isHidden == true {
                    segBarFive4.alpha = 0.5
                    segBarFive5.alpha = 1
                    profileImageView4.isHidden = true
                    profileImageView5.isHidden = false
                } else if profileImageView1.isHidden == true && profileImageView3.isHidden == true {
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                    segBarFive2.alpha = 0.5
                    segBarFive3.alpha = 1
                } else if profileImageView2.isHidden == true {
                    segBarFive3.alpha = 0.5
                    segBarFive4.alpha = 1
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = false
                } else if profileImageView1.isHidden == true {
                    segBarFive2.alpha = 0.5
                    segBarFive3.alpha = 1
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                }
                
                // seg 6 →
            } else {
                if profileImageView1.isHidden == false {
                    profileImageView1.isHidden = true
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = true
                    profileImageView5.isHidden = true
                    profileImageView6.isHidden = true
                    segBarSix1.alpha = 0.5
                    segBarSix2.alpha = 1
                    
                } else if profileImageView5.isHidden == true && profileImageView6.isHidden == false {
                    return
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == false && profileImageView3.isHidden == true {
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                    segBarSix2.alpha = 0.5
                    segBarSix3.alpha = 1
                } else if profileImageView2.isHidden == true && profileImageView3.isHidden == false && profileImageView4.isHidden == true {
                    segBarSix3.alpha = 0.5
                    segBarSix4.alpha = 1
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = false
                } else if profileImageView3.isHidden == true && profileImageView4.isHidden == false && profileImageView5.isHidden == true {
                    segBarSix4.alpha = 0.5
                    segBarSix5.alpha = 1
                    profileImageView4.isHidden = true
                    profileImageView5.isHidden = false
                } else if profileImageView4.isHidden == true && profileImageView6.isHidden == true {
                    segBarSix5.alpha = 0.5
                    segBarSix6.alpha = 1
                    profileImageView5.isHidden = true
                    profileImageView6.isHidden = false
                } else if profileImageView4.isHidden == true {
                    segBarSix5.alpha = 0.5
                    segBarSix6.alpha = 1
                    profileImageView5.isHidden = true
                    profileImageView6.isHidden = false
                } else if profileImageView3.isHidden == true {
                    segBarSix4.alpha = 0.5
                    segBarSix5.alpha = 1
                    profileImageView4.isHidden = true
                    profileImageView5.isHidden = false
                } else if profileImageView2.isHidden == true {
                    segBarSix3.alpha = 0.5
                    segBarSix4.alpha = 1
                    profileImageView3.isHidden = true
                    profileImageView4.isHidden = false
                } else if profileImageView1.isHidden == true {
                    segBarSix2.alpha = 0.5
                    segBarSix3.alpha = 1
                    profileImageView2.isHidden = true
                    profileImageView3.isHidden = false
                }
            }
        } else {
            generator.notificationOccurred(.success)
            
            // seg 2 ←
            if user.profileImageUrl3 == "" && user.profileImageUrl4 == "" && user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    return
                }
                profileImageView1.isHidden = false
                profileImageView2.isHidden = true
                segBarDouble1.alpha = 1
                segBarDouble2.alpha = 0.5
                
                // seg 3 ←
            } else if user.profileImageUrl4 == "" && user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    return
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true {
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    segBarTriple2.alpha = 1
                    segBarTriple3.alpha = 0.5
                } else if profileImageView1.isHidden == true {
                    profileImageView1.isHidden = false
                    profileImageView2.isHidden = true
                    segBarTriple1.alpha = 1
                    segBarTriple2.alpha = 0.5
                }
                
                // seg 4 ←
            } else if user.profileImageUrl5 == "" && user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    return
                } else if profileImageView1.isHidden == true && profileImageView3.isHidden == true && profileImageView4.isHidden == true {
                    profileImageView1.isHidden = false
                    profileImageView2.isHidden = true
                    segBarFour1.alpha = 1
                    segBarFour2.alpha = 0.5
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true && profileImageView3.isHidden == true {
                    profileImageView3.isHidden = false
                    profileImageView4.isHidden = true
                    segBarFour3.alpha = 1
                    segBarFour4.alpha = 0.5
                } else if profileImageView4.isHidden == true {
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    segBarFour2.alpha = 1
                    segBarFour3.alpha = 0.5
                }
                
                // seg 5 ←
            } else if user.profileImageUrl6 == "" {
                
                if profileImageView1.isHidden == false {
                    return
                } else if profileImageView1.isHidden == true && profileImageView3.isHidden == true && profileImageView4.isHidden == true && profileImageView5.isHidden == true {
                    profileImageView1.isHidden = false
                    profileImageView2.isHidden = true
                    segBarFive1.alpha = 1
                    segBarFive2.alpha = 0.5
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true && profileImageView3.isHidden == true && profileImageView4.isHidden == true {
                    profileImageView4.isHidden = false
                    profileImageView5.isHidden = true
                    segBarFive4.alpha = 1
                    segBarFive5.alpha = 0.5
                } else if profileImageView3.isHidden == true && profileImageView5.isHidden == true {
                    profileImageView3.isHidden = false
                    profileImageView4.isHidden = true
                    segBarFive3.alpha = 1
                    segBarFive4.alpha = 0.5
                } else if profileImageView2.isHidden == true && profileImageView4.isHidden == true {
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    segBarFive2.alpha = 1
                    segBarFive3.alpha = 0.5
                }
                
                // seg 6 ←
            } else {
                
                if profileImageView1.isHidden == false {
                    return
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true && profileImageView3.isHidden == true && profileImageView4.isHidden == true && profileImageView5.isHidden == true {
                    profileImageView5.isHidden = false
                    profileImageView6.isHidden = true
                    segBarSix5.alpha = 1
                    segBarSix6.alpha = 0.5
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == false && profileImageView3.isHidden == true {
                    profileImageView1.isHidden = false
                    profileImageView2.isHidden = true
                    segBarSix1.alpha = 1
                    segBarSix2.alpha = 0.5
                } else if profileImageView2.isHidden == true && profileImageView3.isHidden == false && profileImageView4.isHidden == true {
                    profileImageView2.isHidden = false
                    profileImageView3.isHidden = true
                    segBarSix2.alpha = 1
                    segBarSix3.alpha = 0.5
                } else if profileImageView4.isHidden == true && profileImageView6.isHidden == true {
                    profileImageView4.isHidden = false
                    profileImageView5.isHidden = true
                    segBarSix4.alpha = 1
                    segBarSix5.alpha = 0.5
                } else if profileImageView3.isHidden == true && profileImageView5.isHidden == true {
                    profileImageView3.isHidden = false
                    profileImageView4.isHidden = true
                    segBarSix3.alpha = 1
                    segBarSix4.alpha = 0.5
                }
            }
        }
    }
    
    // MARK: - Get count
    
    func getLikeCount(ref: DocumentReference) {
        ref.collection(SHARDS).getDocuments() { (querySnapshot, err) in
            var totalLikeCount = 0
            if  let err = err {
                print("Error total count: \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let likeCount = document.data()[LIKECOUNT] as! Int
                    totalLikeCount += likeCount
                }
            }
            if totalLikeCount > 999 {
                self.likeCountLabel.text = "999"
            } else {
                self.likeCountLabel.text = String(totalLikeCount)
            }
        }
    }
    
    func getTypeCount(ref: DocumentReference) {
        ref.collection(SHARDS).getDocuments() { (querySnapshot, err) in
            var totalTypeCount = 0
            if  let err = err {
                print("Error total count: \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let typeCount = document.data()[TYPECOUNT] as! Int
                    totalTypeCount += typeCount
                }
            }
            if totalTypeCount > 999 {
                self.typeCountLabel.text = "999"
            } else {
                self.typeCountLabel.text = String(totalTypeCount)
            }
        }
    }
    
    // MARK: - Awake from nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ageLabel.text = ""
        nameLabel.text = ""
        residenceLabel.text = ""
        hobbyLbl1.text = ""
        hobbyLbl2.text = ""
        hobbyLbl3.text = ""
        if distanceLabel != nil {
            distanceLabel.text = ""
        }
        
        hobbyLbl1.layer.cornerRadius = 24 / 2
        hobbyLbl2.layer.cornerRadius = 24 / 2
        hobbyLbl3.layer.cornerRadius = 24 / 2
        hobbyLbl1.backgroundColor = UIColor(named: O_GREEN)
        hobbyLbl2.backgroundColor = .systemOrange
        hobbyLbl3.backgroundColor = UIColor(named: O_RED)
        hobbyLbl1.textColor = .white
        hobbyLbl2.textColor = .white
        hobbyLbl3.textColor = .white
        
        profileImageView1.layer.cornerRadius = 15
        profileImageView2.layer.cornerRadius = 15
        profileImageView3.layer.cornerRadius = 15
        profileImageView4.layer.cornerRadius = 15
        profileImageView5.layer.cornerRadius = 15
        profileImageView6.layer.cornerRadius = 15
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 700)
        profileImageView1.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView2.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView3.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView4.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView5.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView6.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        
        statusView.layer.cornerRadius = 12 / 2
        
        communityImageView1.layer.cornerRadius = 15
        communityImageView2.layer.cornerRadius = 15
        communityImageView3.layer.cornerRadius = 15
    }
    
    // MARK: - Helpers
    
    func profileImageUrl_23456Nil() {
        stackViewDouble.isHidden = true
        stackViewTriple.isHidden = true
        stackViewFour.isHidden = true
        stackViewFive.isHidden = true
        stackViewSix.isHidden = true
    }
    
    func profileImageUrl_3456Nil() {
        stackViewDouble.isHidden = false
        stackViewTriple.isHidden = true
        stackViewFour.isHidden = true
        stackViewFive.isHidden = true
        stackViewSix.isHidden = true
        segBarDouble2.alpha = 0.5
    }
    
    func profileImageUrl_456Nil() {
        stackViewDouble.isHidden = true
        stackViewTriple.isHidden = false
        stackViewFour.isHidden = true
        stackViewFive.isHidden = true
        stackViewSix.isHidden = true
        segBarTriple2.alpha = 0.5
        segBarTriple3.alpha = 0.5
    }
    
    func profileImageUrl_56Nil() {
        stackViewDouble.isHidden = true
        stackViewTriple.isHidden = true
        stackViewFour.isHidden = false
        stackViewFive.isHidden = true
        stackViewSix.isHidden = true
        segBarFour2.alpha = 0.5
        segBarFour3.alpha = 0.5
        segBarFour4.alpha = 0.5
    }
    
    func profileImageUrl_6Nil() {
        stackViewDouble.isHidden = true
        stackViewTriple.isHidden = true
        stackViewFour.isHidden = true
        stackViewFive.isHidden = false
        stackViewSix.isHidden = true
        segBarFive2.alpha = 0.5
        segBarFive3.alpha = 0.5
        segBarFive4.alpha = 0.5
        segBarFive5.alpha = 0.5
    }
    
    func profileImageUrlHaveAll() {
        stackViewDouble.isHidden = true
        stackViewTriple.isHidden = true
        stackViewFour.isHidden = true
        stackViewFive.isHidden = true
        stackViewSix.isHidden = false
        segBarSix2.alpha = 0.5
        segBarSix3.alpha = 0.5
        segBarSix4.alpha = 0.5
        segBarSix5.alpha = 0.5
        segBarSix6.alpha = 0.5
    }
}
