//
//  EnterAgeViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterAgeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    
    private var dataArray: [Int] = ([Int])(18...60)
    
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
        
        nextButton.isEnabled = false
        saveUserAge()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    private func saveUserAge() {
        
        let dict = [AGE: Int(ageLabel.text!)]
        updateUser(withValue: dict as [String : Any])

        toEnterProfileImageVC()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        ageLabel.text = "18"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        descriptionLabel.text = "年齢を選択してください。"
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
    
    private func toEnterProfileImageVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterProfileImageVC = storyboard.instantiateViewController(withIdentifier: "EnterProfileImageVC")
            self.present(toEnterProfileImageVC, animated: true, completion: nil)
        }
    }
}

extension EnterAgeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = String(dataArray[row])
        label.textAlignment = NSTextAlignment.center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        ageLabel.text = String(dataArray[row])
    }
}
