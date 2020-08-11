//
//  ModalSearchTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/10.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class ModalSearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var pickerKeyBoard16: PickerKeyboard16!
    @IBOutlet weak var pickerKeyBoard3: PickerKeyboard3!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minSlider: UISlider!
    @IBOutlet weak var maxSlider: UISlider!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func minSlider(_ sender: UISlider) {
        
        let sliderValue: Int = Int(sender.value)
        minLabel.text = String(sliderValue)
        maxSlider.minimumValue = sender.value + 1
        minSlider.maximumValue = maxSlider.value - 1
    }
    
    @IBAction func maxSlider(_ sender: UISlider) {
        
        let sliderValue: Int = Int(sender.value)
        maxLabel.text = String(sliderValue)
        minSlider.maximumValue = sender.value - 1
        maxSlider.minimumValue = minSlider.value + 1
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if genderLabel.text == "選択する" {
            hud.textLabel.text = "出会いたい人の性別を選択してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        let dict = [RESIDENCESEARCH: residenceLabel.text!,
                    MINAGE: Int(minLabel.text!)!,
                    MAXAGE: Int(maxLabel.text!)!] as [String : Any]
        
        if genderLabel.text == "男性" {
            UserDefaults.standard.set(true, forKey: FEMALE)
        } else if genderLabel.text == "女性" {
            UserDefaults.standard.removeObject(forKey: FEMALE)
        }
        
        updateUser(withValue: dict as [String : Any])
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(user)
        }
    }
    
    private func setupUserInfo(_ user: User) {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            genderLabel.text = "男性"
        } else {
            genderLabel.text = "女性"
        }
        self.residenceLabel.text = user.residenceSerch
        self.minLabel.text = String(user.minAge)
        self.maxLabel.text = String(user.maxAge)
        self.minSlider.value = Float(user.minAge)
        self.maxSlider.value = Float(user.maxAge)
    }
    
    private func setupUI() {
        pickerKeyBoard3.delegate = self
        pickerKeyBoard16.delegate = self
        tableView.tableFooterView = UIView()
        
        doneButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        doneButton.layer.shadowColor = UIColor.black.cgColor
        doneButton.layer.shadowOpacity = 0.3
        doneButton.layer.shadowRadius = 4
        doneButton.layer.cornerRadius = 15
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            doneButton.backgroundColor = UIColor(named: O_PINK)
            doneButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            doneButton.backgroundColor = UIColor(named: O_GREEN)
            doneButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            doneButton.backgroundColor = UIColor.white
            doneButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            doneButton.layer.borderColor = UIColor(named: O_BLACK)?.cgColor
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            doneButton.backgroundColor = UIColor(named: O_DARK)
            doneButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
}

extension ModalSearchTableViewController: PickerKeyboard3Delegate {
    func titlesOfPickerViewKeyboard3(_ pickerKeyboard: PickerKeyboard3) -> Array<String> {
        return dataArray3
    }
    
    func didDone3(_ pickerKeyboard: PickerKeyboard3, selectData: String) {
        residenceLabel.text = selectData
    }
}

extension ModalSearchTableViewController: PickerKeyboard16Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard16) -> Array<String> {
        return dataArray16
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard16, selectData: String) {
        genderLabel.text = selectData
    }
}
