//
//  Card.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/08.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class Card: UIView {

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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var nopeView: UIView!
    @IBOutlet weak var nopeLabel: UILabel!
    @IBOutlet weak var typeView: UIView!

    var user: User!
    var cardVC: CardViewController?
    
    func configureCell(_ user: User?) {
        
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
        profileImageView1.layer.cornerRadius = 15
        profileImageView2.layer.cornerRadius = 15
        profileImageView3.layer.cornerRadius = 15
        profileImageView4.layer.cornerRadius = 15
        profileImageView5.layer.cornerRadius = 15
        profileImageView6.layer.cornerRadius = 15
        
        nameLabel.text = user?.username
        residenceLabel.text = user?.residence
        ageLabel.text = String(user!.age) + "歳"

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
    }
    
    @IBAction func infoImageTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailTableViewController
        detailVC.toUserId = user.uid
    
        cardVC?.present(detailVC, animated: true, completion: nil)
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
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true && profileImageView3.isHidden == true {
                    profileImageView3.isHidden = false
                    profileImageView4.isHidden = true
                    segBarFour3.alpha = 1
                    segBarFour4.alpha = 0.5
                } else if profileImageView3.isHidden == true && profileImageView4.isHidden == true {
                    profileImageView1.isHidden = false
                    profileImageView2.isHidden = true
                    segBarFour1.alpha = 1
                    segBarFour2.alpha = 0.5
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
                } else if profileImageView1.isHidden == true && profileImageView2.isHidden == true && profileImageView3.isHidden == true && profileImageView4.isHidden == true {
                    profileImageView4.isHidden = false
                    profileImageView5.isHidden = true
                    segBarFive4.alpha = 1
                    segBarFive5.alpha = 0.5
                } else if profileImageView2.isHidden == false && profileImageView3.isHidden == true && profileImageView4.isHidden == true {
                    profileImageView1.isHidden = false
                    profileImageView2.isHidden = true
                    segBarFive1.alpha = 1
                    segBarFive2.alpha = 0.5
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        likeView.alpha = 0
        nopeView.alpha = 0
        typeView.alpha = 0
        likeView.layer.cornerRadius = 27 / 2
        nopeView.layer.cornerRadius = 27 / 2
        typeView.layer.cornerRadius = 27 / 2
        
        likeLabel.transform = CGAffineTransform(rotationAngle: -.pi / 8)
        nopeLabel.transform = CGAffineTransform(rotationAngle: .pi / 8)
        
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: bounds.height)
        profileImageView1.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView2.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView3.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView4.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView5.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        profileImageView6.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
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
