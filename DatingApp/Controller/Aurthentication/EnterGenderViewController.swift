//
//  EnterGenderViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class EnterGenderViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private var dataArray = ["-", "男性", "女性"]
    private var hud = JGProgressHUD(style: .dark)
    
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
        
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if genderLabel.text != "-" {
            nextButton.isEnabled = false
            saveUserGender()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "性別を選択してください"
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    private func saveUserGender() {
        
        if genderLabel.text == "女性" {
            updateUser(withValue: [GENDER: genderLabel.text as Any, SELECTGENDER: "男性"])
            UserDefaults.standard.set(true, forKey: FEMALE)
            toEnterAgeVC()
        } else {
            updateUser(withValue: [GENDER: genderLabel.text as Any, SELECTGENDER: "女性"])
            UserDefaults.standard.set(true, forKey: MALE)
            toEnterAgeVC()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderLabel.text = "-"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        descriptionLabel.text = "あなたの性別を選択してください。\n性別はあとで変更することができません。"
        nextButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        if UserDefaults.standard.object(forKey: FACEBOOK) != nil || UserDefaults.standard.object(forKey: GOOGLE) != nil {
            backButton.isHidden = true
        } else {
            backButton.isHidden = false
        }
    }
    
    // MARK: - Navigation
    
    private func toEnterAgeVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            hud.dismiss()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterAgeVC = storyboard.instantiateViewController(withIdentifier: "EnterAgeVC")
            self.present(toEnterAgeVC, animated: true, completion: nil)
        }
    }
}

extension EnterGenderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        genderLabel.text = dataArray[row]
    }
}
