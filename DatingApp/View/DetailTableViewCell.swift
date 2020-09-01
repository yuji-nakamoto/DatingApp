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
    
    // MARK: - Helpers
    
    var user: User!
    
    func configureCell(_ user: User?) {
        
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
        if user?.profession == "" {
            professionLabel.text = "未設定"
        } else {
            professionLabel.text = user?.profession
        }
        bodyLabel.text = user?.bodySize
        heightLabel.text = user?.height
        
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
        
        if user?.age == nil {
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
            hobbyLabel.text = (user?.hobby1)! + "," + (user?.hobby2)! + "," + (user?.hobby3)!
            hobbyLabel.font = UIFont.systemFont(ofSize: 12)
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
    
    func currentLocation(_ user: User?, _ currentLocation: CLLocation?) {
        
        guard let _ = currentLocation else { return }
        
        if user?.latitude != "" && user?.longitude != "" {
            let userLocation = CLLocation(latitude: Double(user!.latitude)!, longitude: Double(user!.longitude)!)
            let distanceInKM: CLLocationDistance = userLocation.distance(from: currentLocation!) / 1000

            distanceLabel.text = String(format: "%.f Km", distanceInKM)
            distanceLabel.isHidden = false
        } else {
            distanceLabel.isHidden = true
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ageLabel.text = ""
        
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
    }
    
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
