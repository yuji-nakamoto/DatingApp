//
//  EnterResidenceViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterResidenceViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    private var user: User!
    private var dataArray = ["-", "海外", "北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知", "三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山", "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川", "愛媛", "高知", "福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if residenceLabel.text != "-" {
            
            nextButton.isEnabled = false
            saveUserProfession()
        } else {
            hud.textLabel.text = "居住地を選択してください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - User
    
    private func loadUser() {
        
        fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    private func saveUserProfession() {
        
        let user = User()
        user.uid = self.user.uid
        user.profileImageUrls = self.user.profileImageUrls
        user.profession = self.user.profession
        user.residence = self.residenceLabel.text
        
        updateUserData2(user)
        toTabBerVC()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        residenceLabel.text = "-"
        descriptionLabel.text = "居住地を選択してください。\nあとで変更することもできます。"
        nextButton.layer.cornerRadius = 50 / 2
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
    }
    
    // MARK: - Navigation

    private func toTabBerVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UserDefaults.standard.set(true, forKey: RCOMPLETION)
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabBerVC")
            self.present(toTabBerVC, animated: true, completion: nil)
        }
    }
}

extension EnterResidenceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
