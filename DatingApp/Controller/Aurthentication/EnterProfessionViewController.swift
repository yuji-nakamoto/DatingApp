//
//  EnterProfessionViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterProfessionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var anyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    private var user: User!
    private var dataArray = ["選択しない", "会社員", "医師", "弁護士", "会計士", "経営者", "大手商社", "外資金融", "大手企業", "クリエイター", "IT関連", "航空関係", "芸能・モデル", "アパレル", "秘書", "看護師", "医療関係", "保育士", "自由業", "学生", "栄養士", "教育関連", "食品関連", "製造", "保険", "不動産", "美容関係", "建築関係", "旅行関係", "福祉・介護", "フリーランス", "その他"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if professionLabel.text != "選択しない" {
            
            nextButton.isEnabled = false
            saveUserProfession()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "職業を選択してください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - User
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    private func saveUserProfession() {
        
        let dict = [PROFESSION: professionLabel.text]
        updateUser(withValue: dict as [String : Any])
        toEnterResidenceVC()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        professionLabel.text = "選択しない"
        descriptionLabel.text = "職業を選択してください。\nあとで選択する場合はスキップを押してください。"
        anyLabel.layer.borderWidth = 1
        anyLabel.layer.borderColor = UIColor.systemGray3.cgColor
        nextButton.layer.cornerRadius = 50 / 2
        nextButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowRadius = 4
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
    }
    
    // MARK: - Navigation

    private func toEnterResidenceVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterResidenceVC = storyboard.instantiateViewController(withIdentifier: "EnterResidenceVC")
            self.present(toEnterResidenceVC, animated: true, completion: nil)
        }
    }
}

extension EnterProfessionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        professionLabel.text = dataArray[row]
    }
}
