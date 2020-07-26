//
//  EnterGenderViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterGenderViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    
    private var user: User!
    private var dataArray = ["-", "男性", "女性"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        configureSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if genderLabel.text != "-" {
            
            nextButton.isEnabled = false
            saveUserGender()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "性別を選択してください。"
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
    
    private func saveUserGender() {
        
        let dict = [GENDER: genderLabel.text]
        updateUser(withValue: dict as [String : Any])

        if genderLabel.text == "男性" {
            toEnterNameVC()
        } else {
            UserDefaults.standard.set(true, forKey: FEMALE)
            toEnterNameVC()
        }
    }
    
    // MARK: - Helpers
    
    private func configureSetup() {
        
        UserDefaults.standard.removeObject(forKey: FEMALE)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderLabel.text = "-"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        descriptionLabel.text = "性別を選択してください。"
        nextButton.layer.cornerRadius = 50 / 2
        nextButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowRadius = 4
    }
    
    // MARK: - Navigation
    
    private func toEnterNameVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterNameVC = storyboard.instantiateViewController(withIdentifier: "EnterNameVC")
            self.present(toEnterNameVC, animated: true, completion: nil)
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
