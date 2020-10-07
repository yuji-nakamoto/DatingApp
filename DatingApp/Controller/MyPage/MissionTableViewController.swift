//
//  MissionTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/09.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class MissionTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var loginCountLbl1: UILabel!
    @IBOutlet weak var loginCountLbl2: UILabel!
    @IBOutlet weak var likeCountLbl1: UILabel!
    @IBOutlet weak var likeCountLbl2: UILabel!
    @IBOutlet weak var typeCountLbl1: UILabel!
    @IBOutlet weak var typeCountLbl2: UILabel!
    @IBOutlet weak var messageCountLbl1: UILabel!
    @IBOutlet weak var messageCountLbl2: UILabel!
    @IBOutlet weak var matchCountLbl1: UILabel!
    @IBOutlet weak var matchCountLbl2: UILabel!
    @IBOutlet weak var footCountLbl1: UILabel!
    @IBOutlet weak var footCountLbl2: UILabel!
    @IBOutlet weak var communityCountLbl1: UILabel!
    @IBOutlet weak var communityCountLbl2: UILabel!
    @IBOutlet weak var loginButton1: UIButton!
    @IBOutlet weak var loginButton2: UIButton!
    @IBOutlet weak var likeButton1: UIButton!
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var typeButton1: UIButton!
    @IBOutlet weak var typeButton2: UIButton!
    @IBOutlet weak var messageButton1: UIButton!
    @IBOutlet weak var messageButton2: UIButton!
    @IBOutlet weak var matchButton1: UIButton!
    @IBOutlet weak var matchButton2: UIButton!
    @IBOutlet weak var footButton1: UIButton!
    @IBOutlet weak var footButton2: UIButton!
    @IBOutlet weak var communityButton1: UIButton!
    @IBOutlet weak var communityButton2: UIButton!
    @IBOutlet weak var communityButton3: UIButton!
    @IBOutlet weak var communityButton4: UIButton!
    @IBOutlet weak var profileButton1: UIButton!
    @IBOutlet weak var kaiganButton: UIButton!
    @IBOutlet weak var toshiButton: UIButton!
    @IBOutlet weak var missionClearButton: UIButton!
    @IBOutlet weak var loginAchievementLbl1: UILabel!
    @IBOutlet weak var loginAchievementLbl2: UILabel!
    @IBOutlet weak var likeAchievementLbl1: UILabel!
    @IBOutlet weak var likeAchievementLbl2: UILabel!
    @IBOutlet weak var typeAchievementLbl1: UILabel!
    @IBOutlet weak var typeAchievementLbl2: UILabel!
    @IBOutlet weak var messageAchievementLbl1: UILabel!
    @IBOutlet weak var messageAchievementLbl2: UILabel!
    @IBOutlet weak var matchAchievementLbl1: UILabel!
    @IBOutlet weak var matchAchievementLbl2: UILabel!
    @IBOutlet weak var footAchievementLbl1: UILabel!
    @IBOutlet weak var footAchievementLbl2: UILabel!
    @IBOutlet weak var profileAchievementLbl1: UILabel!
    @IBOutlet weak var communityAchievementLbl1: UILabel!
    @IBOutlet weak var communityAchievementLbl2: UILabel!
    @IBOutlet weak var communityAchievementLbl3: UILabel!
    @IBOutlet weak var communityAchievementLbl4: UILabel!
    @IBOutlet weak var kaiganAchievementLbl: UILabel!
    @IBOutlet weak var toshiAchievementLbl: UILabel!
    @IBOutlet weak var missionClearAchievementLbl: UILabel!
    
    lazy var buttons = [loginButton1,loginButton2,likeButton1,likeButton2,typeButton1,typeButton2,messageButton1,messageButton2,matchButton1,matchButton2,footButton1,footButton2,profileButton1,communityButton1,communityButton2,communityButton3,communityButton4,kaiganButton,toshiButton,missionClearButton]
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButtonPressed1(_ sender: Any) {
        loginButton1.setTitle("  受け取り済み  ", for: .normal)
        loginButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        loginButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        loginButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        loginButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, LOGINGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func loginButtonPressed2(_ sender: Any) {
        loginButton2.setTitle("  受け取り済み  ", for: .normal)
        loginButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        loginButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        loginButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        loginButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, LOGINGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func likeButtonPressed1(_ sender: Any) {
        likeButton1.setTitle("  受け取り済み  ", for: .normal)
        likeButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        likeButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        likeButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        likeButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, LIKEGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func likeButtonPressed2(_ sender: Any) {
        likeButton2.setTitle("  受け取り済み  ", for: .normal)
        likeButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        likeButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        likeButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        likeButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, LIKEGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func typeButtonPressed1(_ sender: Any) {
        typeButton1.setTitle("  受け取り済み  ", for: .normal)
        typeButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        typeButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        typeButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        typeButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, TYPEGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func typeButtonPressed2(_ sender: Any) {
        typeButton2.setTitle("  受け取り済み  ", for: .normal)
        typeButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        typeButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        typeButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        typeButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 3, TYPEGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func messageButtonPressed1(_ sender: Any) {
        messageButton1.setTitle("  受け取り済み  ", for: .normal)
        messageButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        messageButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        messageButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        messageButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, MESSAGEGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func messageButtonPressed2(_ sender: Any) {
        messageButton2.setTitle("  受け取り済み  ", for: .normal)
        messageButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        messageButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        messageButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        messageButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 4, MESSAGEGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func matchButtonPressed1(_ sender: Any) {
        matchButton1.setTitle("  受け取り済み  ", for: .normal)
        matchButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        matchButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        matchButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        matchButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, MATCHGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func matchButtonPressed2(_ sender: Any) {
        matchButton2.setTitle("  受け取り済み  ", for: .normal)
        matchButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        matchButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        matchButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        matchButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 8, MATCHGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func footButtonPressed1(_ sender: Any) {
        footButton1.setTitle("  受け取り済み  ", for: .normal)
        footButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        footButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        footButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        footButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, FOOTGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func footButtonPressed2(_ sender: Any) {
        footButton2.setTitle("  受け取り済み  ", for: .normal)
        footButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        footButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        footButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        footButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 2, FOOTGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func communityButtonPressed1(_ sender: Any) {
        communityButton1.setTitle("  受け取り済み  ", for: .normal)
        communityButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 1, COMMUNITYGETPT1: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func communityButtonPressed2(_ sender: Any) {
        communityButton2.setTitle("  受け取り済み  ", for: .normal)
        communityButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton2.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 1, COMMUNITYGETPT2: true, NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func communityButtonPressed3(_ sender: Any) {
        communityButton3.setTitle("  受け取り済み  ", for: .normal)
        communityButton3.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton3.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton3.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton3.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 1,
                               COMMUNITYGETPT3: true,
                               NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func communityButtonPressed4(_ sender: Any) {
        communityButton4.setTitle("  受け取り済み  ", for: .normal)
        communityButton4.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton4.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton4.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton4.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 1,
                               COMMUNITYGETPT4: true,
                               MCOMMUNITY: FieldValue.delete(),
                               NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func profileButtonPressed1(_ sender: Any) {
        profileButton1.setTitle("  受け取り済み  ", for: .normal)
        profileButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        profileButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        profileButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        profileButton1.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 3,
                               PROFILEGETPT1: true,
                               MPROFILE: FieldValue.delete(),
                               NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func kaiganButtonPressed(_ sender: Any) {
        kaiganButton.setTitle("  受け取り済み  ", for: .normal)
        kaiganButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        kaiganButton.setTitleColor(UIColor(named: O_RED), for: .normal)
        kaiganButton.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        kaiganButton.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 1,
                               KAIGANGETPT: true,
                               MKAIGAN: FieldValue.delete(),
                               NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func toshiButtonPressed(_ sender: Any) {
        toshiButton.setTitle("  受け取り済み  ", for: .normal)
        toshiButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        toshiButton.setTitleColor(UIColor(named: O_RED), for: .normal)
        toshiButton.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        toshiButton.isEnabled = false
        updateUser(withValue: [POINTS: self.user.points + 1,
                               TOSHIGETPT: true,
                               MTOSHI: FieldValue.delete(),
                               NEWMISSION: false])
        UserDefaults.standard.set(true, forKey: REFRESH3)
        fetchUser()
    }
    @IBAction func missionClearButtonPressed(_ sender: Any) {
        
        if user.loginGetPt1 && user.loginGetPt2 && user.typeGetPt1 && user.typeGetPt2 && user.messageGetPt1 && user.messageGetPt2 && user.matchGetPt1 && user.matchGetPt2 && user.footGetPt1 && user.footGetPt2 && user.communityGetPt1 && user.communityGetPt2 && user.communityGetPt3 && user.communityGetPt4 && user.profileGetPt1 && user.toshiGetPt && user.kaiganGetPt {
            missionClearButton.setTitle("  受け取り済み  ", for: .normal)
            missionClearButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
            missionClearButton.setTitleColor(UIColor(named: O_RED), for: .normal)
            missionClearButton.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
            missionClearButton.isEnabled = false
            updateUser(withValue: [ITEM7: 1,
                                   MISSIONCLEARGETITEM: true,
                                   NEWMISSION: false,
                                   MCOMMUNITYCOUNT: FieldValue.delete(),
                                   LOGINGETPT1: FieldValue.delete(),
                                   LOGINGETPT2: FieldValue.delete(),
                                   LIKEGETPT1: FieldValue.delete(),
                                   LIKEGETPT2: FieldValue.delete(),
                                   TYPEGETPT1: FieldValue.delete(),
                                   TYPEGETPT2: FieldValue.delete(),
                                   MESSAGEGETPT1: FieldValue.delete(),
                                   MESSAGEGETPT2: FieldValue.delete(),
                                   MATCHGETPT1: FieldValue.delete(),
                                   MATCHGETPT2: FieldValue.delete(),
                                   FOOTGETPT1: FieldValue.delete(),
                                   FOOTGETPT2: FieldValue.delete(),
                                   COMMUNITYGETPT1: FieldValue.delete(),
                                   COMMUNITYGETPT2: FieldValue.delete(),
                                   COMMUNITYGETPT3: FieldValue.delete(),
                                   COMMUNITYGETPT4: FieldValue.delete(),
                                   PROFILEGETPT1: FieldValue.delete(),
                                   TOSHIGETPT: FieldValue.delete(),
                                   KAIGANGETPT: FieldValue.delete(),])
            UserDefaults.standard.set(true, forKey: REFRESH3)
            fetchUser()
            
        } else {
            hud.show(in: self.view)
            hud.textLabel.text = "未受け取りの報酬を先に受け取ってください"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(self.user)
        }
    }
    
    // MARK: - Helpers
    
    private func setupUserInfo(_ user: User) {
        
        if user.mLoginCount >= 14 {
            loginCountLbl1.text = "0人"
            loginCountLbl1.textColor = UIColor(named: O_RED)
            loginButton1.setTitle("  受け取る  ", for: .normal)
            loginButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            loginButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            loginButton1.isEnabled = true
            
        } else {
            loginCountLbl1.text = String(14 - user.mLoginCount) + "回"
        }
        
        if user.mLoginCount >= 28 {
            loginCountLbl2.text = "0人"
            loginCountLbl2.textColor = UIColor(named: O_RED)
            loginButton2.setTitle("  受け取る  ", for: .normal)
            loginButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            loginButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            loginButton2.isEnabled = true
            
        } else {
            loginCountLbl2.text = String(28 - user.mLoginCount) + "回"
        }
        
        if user.mLikeCount >= 25 {
            likeCountLbl1.text = "0人"
            likeCountLbl1.textColor = UIColor(named: O_RED)
            likeButton1.setTitle("  受け取る  ", for: .normal)
            likeButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            likeButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            likeButton1.isEnabled = true
            
        } else {
            likeCountLbl1.text = String(25 - user.mLikeCount) + "人"
        }
        if user.mLikeCount >= 50 {
            likeCountLbl2.text = "0人"
            likeCountLbl2.textColor = UIColor(named: O_RED)
            likeButton2.setTitle("  受け取る  ", for: .normal)
            likeButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            likeButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            likeButton2.isEnabled = true
            
        } else {
            likeCountLbl2.text = String(50 - user.mLikeCount) + "人"
        }
        
        if user.mTypeCount >= 10 {
            typeCountLbl1.text = "0人"
            typeCountLbl1.textColor = UIColor(named: O_RED)
            typeButton1.setTitle("  受け取る  ", for: .normal)
            typeButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            typeButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            typeButton1.isEnabled = true
            
        } else {
            typeCountLbl1.text = String(10 - user.mTypeCount) + "人"
        }
        if user.mTypeCount >= 30 {
            typeCountLbl2.text = "0人"
            typeCountLbl2.textColor = UIColor(named: O_RED)
            typeButton2.setTitle("  受け取る  ", for: .normal)
            typeButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            typeButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            typeButton2.isEnabled = true
            
        } else {
            typeCountLbl2.text = String(30 - user.mTypeCount) + "人"
        }
        
        if user.mMessageCount >= 5 {
            messageCountLbl1.text = "0人"
            messageCountLbl1.textColor = UIColor(named: O_RED)
            messageButton1.setTitle("  受け取る  ", for: .normal)
            messageButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            messageButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            messageButton1.isEnabled = true
            
        } else {
            messageCountLbl1.text = String(5 - user.mMessageCount) + "人"
        }
        if user.mMessageCount >= 15 {
            messageCountLbl2.text = "0人"
            messageCountLbl2.textColor = UIColor(named: O_RED)
            messageButton2.setTitle("  受け取る  ", for: .normal)
            messageButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            messageButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            messageButton2.isEnabled = true
            
        } else {
            messageCountLbl2.text = String(15 - user.mMessageCount) + "人"
        }
        
        if user.mMatchCount >= 1 {
            matchCountLbl1.text = "0人"
            matchCountLbl1.textColor = UIColor(named: O_RED)
            matchButton1.setTitle("  受け取る  ", for: .normal)
            matchButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            matchButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            matchButton1.isEnabled = true
            
        } else {
            matchCountLbl1.text = String(1 - user.mMatchCount) + "人"
        }
        
        if user.mMatchCount >= 5 {
            matchCountLbl2.text = "0人"
            matchCountLbl2.textColor = UIColor(named: O_RED)
            matchButton2.setTitle("  受け取る  ", for: .normal)
            matchButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            matchButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            matchButton2.isEnabled = true
            
        } else {
            matchCountLbl2.text = String(5 - user.mMatchCount) + "人"
        }
        
        if user.mFootCount >= 50 {
            footCountLbl1.text = "0人"
            footCountLbl1.textColor = UIColor(named: O_RED)
            footButton1.setTitle("  受け取る  ", for: .normal)
            footButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            footButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            footButton1.isEnabled = true
            
        } else {
            footCountLbl1.text = String(50 - user.mFootCount) + "人"
        }
        if user.mFootCount >= 100 {
            footCountLbl2.text = "0人"
            footCountLbl2.textColor = UIColor(named: O_RED)
            footButton2.setTitle("  受け取る  ", for: .normal)
            footButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            footButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            footButton2.isEnabled = true
            
        } else {
            footCountLbl2.text = String(100 - user.mFootCount) + "人"
        }
        
        if user.mCommunityCount >= 1 {
            communityCountLbl1.text = "0人"
            communityCountLbl1.textColor = UIColor(named: O_RED)
            communityButton1.setTitle("  受け取る  ", for: .normal)
            communityButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            communityButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            communityButton1.isEnabled = true
            
        } else {
            communityCountLbl1.text = String(1 - user.mCommunityCount) + "つ"
        }
        if user.mCommunityCount >= 3 {
            communityCountLbl2.text = "0人"
            communityCountLbl2.textColor = UIColor(named: O_RED)
            communityButton2.setTitle("  受け取る  ", for: .normal)
            communityButton2.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            communityButton2.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            communityButton2.isEnabled = true
            
        } else {
            communityCountLbl2.text = String(3 - user.mCommunityCount) + "つ"
        }
        
        if user.createCommunityCount >= 1 {
            communityButton3.setTitle("  受け取る  ", for: .normal)
            communityButton3.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            communityButton3.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            communityButton3.isEnabled = true
        }
        
        if user.mCommunity == true {
            communityButton4.setTitle("  受け取る  ", for: .normal)
            communityButton4.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            communityButton4.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            communityButton4.isEnabled = true
        }
        
        if user.mProfile == true {
            profileButton1.setTitle("  受け取る  ", for: .normal)
            profileButton1.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            profileButton1.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            profileButton1.isEnabled = true
        }
        
        if user.mKaigan == true {
            kaiganButton.setTitle("  受け取る  ", for: .normal)
            kaiganButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            kaiganButton.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            kaiganButton.isEnabled = true
        }
        
        if user.mToshi == true {
            toshiButton.setTitle("  受け取る  ", for: .normal)
            toshiButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            toshiButton.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            toshiButton.isEnabled = true
        }
        
        if user.mMissionClear == true {
            missionClearButton.setTitle("  受け取る  ", for: .normal)
            missionClearButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            missionClearButton.layer.borderColor = (UIColor(named: O_GREEN)?.cgColor)
            missionClearButton.isEnabled = true
        }
        
        // MARK: - Get point
        
        if user.loginGetPt1 == true {
            setLogin1()
        }
        if user.loginGetPt2 == true {
            setLogin2()
        }
        
        if user.likeGetPt1 == true {
            setLike1()
        }
        if user.likeGetPt2 == true {
            setLike2()
        }
        
        if user.typeGetPt1 == true {
            setType1()
        }
        if user.typeGetPt2 == true {
            setType2()
        }
        
        if user.messageGetPt1 == true {
            setMessage1()
        }
        if user.messageGetPt2 == true {
            setMessage2()
        }
        
        if user.matchGetPt1 == true {
            setMatch1()
        }
        if user.matchGetPt2 == true {
            setMatch2()
        }
        
        if user.footGetPt1 == true {
            setFoot1()
        }
        if user.footGetPt2 == true {
            setFoot2()
        }
        
        if user.communityGetPt1 == true {
            setCommunity1()
        }
        if user.communityGetPt2 == true {
            setCommunity2()
        }
        if user.communityGetPt3 == true {
            setCommunity3()
        }
        if user.communityGetPt4 == true {
            setCommunity4()
        }
        
        if user.profileGetPt1 == true {
            setProfile()
        }
        
        if user.kaiganGetPt == true {
            setKaigan()
        }
        
        if user.toshiGetPt == true {
            setToshi()
        }
        
        if user.missionClearGetItem == true {
            
            setLogin1();setLogin2();setLike1();setLike2();setType1();setType2();setMessage1();setMessage2();setMatch1();setMatch2();setFoot1();setFoot2();setCommunity1();setCommunity2();setCommunity3();setCommunity4();setProfile();setKaigan();setToshi();setMission()
        }
    }
    
    // MARK: - Set label && button
    
    private func setLogin1() {
        loginCountLbl1.text = "0人"
        loginCountLbl1.textColor = UIColor(named: O_RED)
        loginButton1.setTitle("  受け取り済み  ", for: .normal)
        loginButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        loginButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        loginButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        loginButton1.isEnabled = false
        loginAchievementLbl1.isHidden = true
    }
    
    private func setLogin2() {
        loginCountLbl2.text = "0人"
        loginCountLbl2.textColor = UIColor(named: O_RED)
        loginButton2.setTitle("  受け取り済み  ", for: .normal)
        loginButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        loginButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        loginButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        loginButton2.isEnabled = false
        loginAchievementLbl2.isHidden = true
    }
    
    private func setLike1() {
        likeCountLbl1.text = "0人"
        likeCountLbl1.textColor = UIColor(named: O_RED)
        likeButton1.setTitle("  受け取り済み  ", for: .normal)
        likeButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        likeButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        likeButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        likeButton1.isEnabled = false
        likeAchievementLbl1.isHidden = true
    }
    
    private func setLike2() {
        likeCountLbl2.text = "0人"
        likeCountLbl2.textColor = UIColor(named: O_RED)
        likeButton2.setTitle("  受け取り済み  ", for: .normal)
        likeButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        likeButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        likeButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        likeButton2.isEnabled = false
        likeAchievementLbl2.isHidden = true
    }
    
    private func setType1() {
        typeCountLbl1.text = "0人"
        typeCountLbl1.textColor = UIColor(named: O_RED)
        typeButton1.setTitle("  受け取り済み  ", for: .normal)
        typeButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        typeButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        typeButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        typeButton1.isEnabled = false
        typeAchievementLbl1.isHidden = true
    }
    
    private func setType2() {
        typeCountLbl2.text = "0人"
        typeCountLbl2.textColor = UIColor(named: O_RED)
        typeButton2.setTitle("  受け取り済み  ", for: .normal)
        typeButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        typeButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        typeButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        typeButton2.isEnabled = false
        typeAchievementLbl2.isHidden = true
    }
    
    private func setMessage1() {
        messageCountLbl1.text = "0人"
        messageCountLbl1.textColor = UIColor(named: O_RED)
        messageButton1.setTitle("  受け取り済み  ", for: .normal)
        messageButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        messageButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        messageButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        messageButton1.isEnabled = false
        messageAchievementLbl1.isHidden = true
    }
    
    private func setMessage2() {
        messageCountLbl2.text = "0人"
        messageCountLbl2.textColor = UIColor(named: O_RED)
        messageButton2.setTitle("  受け取り済み  ", for: .normal)
        messageButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        messageButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        messageButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        messageButton2.isEnabled = false
        messageAchievementLbl2.isHidden = true
    }
    
    private func setMatch1() {
        matchCountLbl1.text = "0人"
        matchCountLbl1.textColor = UIColor(named: O_RED)
        matchButton1.setTitle("  受け取り済み  ", for: .normal)
        matchButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        matchButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        matchButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        matchButton1.isEnabled = false
        matchAchievementLbl1.isHidden = true
    }
    
    private func setMatch2() {
        matchCountLbl2.text = "0人"
        matchCountLbl2.textColor = UIColor(named: O_RED)
        matchButton2.setTitle("  受け取り済み  ", for: .normal)
        matchButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        matchButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        matchButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        matchButton2.isEnabled = false
        matchAchievementLbl2.isHidden = true
    }
    
    private func setFoot1() {
        footCountLbl1.text = "0人"
        footCountLbl1.textColor = UIColor(named: O_RED)
        footButton1.setTitle("  受け取り済み  ", for: .normal)
        footButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        footButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        footButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        footButton1.isEnabled = false
        footAchievementLbl1.isHidden = true
    }
    
    private func setFoot2() {
        footCountLbl2.text = "0人"
        footCountLbl2.textColor = UIColor(named: O_RED)
        footButton2.setTitle("  受け取り済み  ", for: .normal)
        footButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        footButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        footButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        footButton2.isEnabled = false
        footAchievementLbl2.isHidden = true
    }
    
    private func setCommunity1() {
        communityCountLbl1.text = "0人"
        communityCountLbl1.textColor = UIColor(named: O_RED)
        communityButton1.setTitle("  受け取り済み  ", for: .normal)
        communityButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton1.isEnabled = false
        communityAchievementLbl1.isHidden = true
    }
    private func setCommunity2() {
        communityCountLbl2.text = "0人"
        communityCountLbl2.textColor = UIColor(named: O_RED)
        communityButton2.setTitle("  受け取り済み  ", for: .normal)
        communityButton2.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton2.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton2.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton2.isEnabled = false
        communityAchievementLbl2.isHidden = true
    }
    private func setCommunity3() {
        communityButton3.setTitle("  受け取り済み  ", for: .normal)
        communityButton3.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton3.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton3.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton3.isEnabled = false
        communityAchievementLbl3.isHidden = true
    }
    private func setCommunity4() {
        communityButton4.setTitle("  受け取り済み  ", for: .normal)
        communityButton4.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        communityButton4.setTitleColor(UIColor(named: O_RED), for: .normal)
        communityButton4.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        communityButton4.isEnabled = false
        communityAchievementLbl4.isHidden = true
    }
    
    private func setProfile() {
        profileButton1.setTitle("  受け取り済み  ", for: .normal)
        profileButton1.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        profileButton1.setTitleColor(UIColor(named: O_RED), for: .normal)
        profileButton1.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        profileButton1.isEnabled = false
        profileAchievementLbl1.isHidden = true
    }
    
    private func setKaigan() {
        kaiganButton.setTitle("  受け取り済み  ", for: .normal)
        kaiganButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        kaiganButton.setTitleColor(UIColor(named: O_RED), for: .normal)
        kaiganButton.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        kaiganButton.isEnabled = false
        kaiganAchievementLbl.isHidden = true
    }
    
    private func setToshi() {
        toshiButton.setTitle("  受け取り済み  ", for: .normal)
        toshiButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        toshiButton.setTitleColor(UIColor(named: O_RED), for: .normal)
        toshiButton.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        toshiButton.isEnabled = false
        toshiAchievementLbl.isHidden = true
    }
    
    private func setMission() {
        missionClearButton.setTitle("  受け取り済み  ", for: .normal)
        missionClearButton.titleLabel?.font = UIFont(name: "HiraMaruProN-W4", size: 13)
        missionClearButton.setTitleColor(UIColor(named: O_RED), for: .normal)
        missionClearButton.layer.borderColor = (UIColor(named: O_RED)?.cgColor)
        missionClearButton.isEnabled = false
        missionClearAchievementLbl.isHidden = true
    }
    
    private func setupUI() {
        navigationItem.title = "ミッション"
        tableView.tableFooterView = UIView()
        buttons.forEach({ $0?.layer.cornerRadius = 5 })
        buttons.forEach({ $0?.layer.borderWidth = 1 })
        buttons.forEach({ $0?.layer.borderColor = UIColor.systemGray.cgColor })
        buttons.forEach({ $0?.isEnabled = false })
    }
}
