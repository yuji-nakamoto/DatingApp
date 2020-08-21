//
//  EnterResidenceMeetViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class EnterResidenceMeetController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    private var hud = JGProgressHUD(style: .dark)
    private var dataArray = ["-", "こだわらない", "海外", "北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知", "三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山", "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川", "愛媛", "高知", "福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        indicator.startAnimating()
        self.prepareSave()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save

    private func saveUserProfession() {
        
        let date: Double = Date().timeIntervalSince1970
        let dict = [RESIDENCESEARCH: residenceLabel.text!,
                    SELFINTRO: "はじめまして！",
                    COMMENT: "",
                    BODYSIZE: "未設定",
                    HEIGHT: "未設定",
                    BLOOD: "未設定",
                    EDUCATION: "未設定",
                    BIRTHPLACE: "未設定",
                    DETAILMAP: "",
                    MARRIAGEHISTORY: "未設定",
                    MARRIAGE: "未設定",
                    CHILD1: "未設定",
                    CHILD2: "未設定",
                    HOUSEMATE: "未設定",
                    HOLIDAY: "未設定",
                    LIQUOR: "未設定",
                    TOBACCO: "未設定",
                    HOBBY1: "",
                    STATUS: "online",
                    DATE: date,
                    LASTCHANGE: Timestamp(date: Date())] as [String : Any]
        
        indicator.stopAnimating()
        updateUser(withValue: dict as [String : Any])
        createLikeCounter(ref: COLLECTION_LIKECOUNTER.document(User.currentUserId()), numShards: 10)
        createTypeCounter(ref: COLLECTION_TYPECOUNTER.document(User.currentUserId()), numShards: 10)
        toTabBerVC()
    }
    
    // MARK: - Helpers
    
    private func prepareSave() {
        
        if residenceLabel.text != "-" {
            nextButton.isEnabled = false
            saveUserProfession()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "居住地を選択してください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            indicator.stopAnimating()
        }
    }
    
    private func createLikeCounter(ref: DocumentReference, numShards: Int) {
        ref.setData(["numShards": numShards]){ (err) in
            for i in 0...numShards {
                ref.collection("shards").document(String(i)).setData([LIKECOUNT: 0])
            }
        }
    }
    
    private func createTypeCounter(ref: DocumentReference, numShards: Int) {
        ref.setData(["numShards": numShards]){ (err) in
            for i in 0...numShards {
                ref.collection("shards").document(String(i)).setData([TYPECOUNT: 0])
            }
        }
    }
    
    private func setupUI() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        residenceLabel.text = "-"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        descriptionLabel.text = "出会いたい人の居住地を選択してください。\nあとで変更することができます。"
        nextButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
    }
    
    // MARK: - Navigation

    private func toTabBerVC() {
        
        if UserDefaults.standard.object(forKey: FACEBOOK) != nil {
            UserDefaults.standard.set(true, forKey: FACEBOOK2)
        }
        if UserDefaults.standard.object(forKey: GOOGLE) != nil {
            UserDefaults.standard.set(true, forKey: GOOGLE2)
        }
        if UserDefaults.standard.object(forKey: APPLE) != nil {
            UserDefaults.standard.set(true, forKey: APPLE2)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UserDefaults.standard.removeObject(forKey: TO_VERIFIED_VC)
            UserDefaults.standard.set(true, forKey: FOOTSTEP_ON)
            UserDefaults.standard.set(true, forKey: MESSAGE_ON)
            UserDefaults.standard.set(true, forKey: LIKE_ON)
            UserDefaults.standard.set(true, forKey: TYPE_ON)
            UserDefaults.standard.set(true, forKey: MATCH_ON)
            UserDefaults.standard.set(true, forKey: WHITE)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabBerVC")
            self.present(toTabBerVC, animated: true, completion: nil)
        }
    }
}

extension EnterResidenceMeetController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = dataArray[row]
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        residenceLabel.text = dataArray[row]
    }
}
