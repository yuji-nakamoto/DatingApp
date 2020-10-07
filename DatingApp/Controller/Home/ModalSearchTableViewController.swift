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
    @IBOutlet weak var pickerKeyBoard1: PickerKeyboard1!
    @IBOutlet weak var pickerKeyBoard2: PickerKeyboard2!
    @IBOutlet weak var pickerKeyBoard6: PickerKeyboard6!
    @IBOutlet weak var pickerKeyBoard4: PickerKeyboard4!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightLabel2: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minSlider: UISlider!
    @IBOutlet weak var maxSlider: UISlider!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    private var dataArray: [Int] = ([Int])(130...200)
    
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
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if genderLabel.text == "選択する" {
            hud.textLabel.text = "出会いたい人の性別を選択してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        let dict = [S_RESIDENCE: residenceLabel.text!,
                    S_BODY: bodyLabel.text!,
                    S_BLOOD: bloodLabel.text!,
                    S_HEIGHT: Int(heightLabel2.text!) as Any,
                    S_PROFESSION: professionLabel.text!,
                    MINAGE: Int(minLabel.text!)!,
                    MAXAGE: Int(maxLabel.text!)!] as [String : Any]
        
        if genderLabel.text == "男性" {
            updateUser(withValue: [SELECTGENDER: "男性"])
            UserDefaults.standard.set(true, forKey: MALE)
        } else if genderLabel.text == "女性" {
            updateUser(withValue: [SELECTGENDER: "女性"])
            UserDefaults.standard.removeObject(forKey: MALE)
        }
        
        if residenceLabel.text == "こだわらない" {
            UserDefaults.standard.set(true, forKey: ALL)
        } else {
            UserDefaults.standard.removeObject(forKey: ALL)
        }
        
        if heightLabel.text == "こだわらない" {
            UserDefaults.standard.removeObject(forKey: HEIGHT)
        } else {
            UserDefaults.standard.set(true, forKey: HEIGHT)
        }
        
        if bodyLabel.text == "こだわらない" {
            UserDefaults.standard.removeObject(forKey: BODYSIZE)
        } else {
            UserDefaults.standard.set(true, forKey: BODYSIZE)
        }
        
        if bloodLabel.text == "こだわらない" {
            UserDefaults.standard.removeObject(forKey: BLOOD)
        } else {
            UserDefaults.standard.set(true, forKey: BLOOD)
        }
        
        if professionLabel.text == "こだわらない" {
            UserDefaults.standard.removeObject(forKey: PROFESSION)
        } else {
            UserDefaults.standard.set(true, forKey: PROFESSION)
        }
        updateUser(withValue: dict as [String : Any])
        UserDefaults.standard.set(true, forKey: REFRESH)
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
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            genderLabel.text = "男性"
        } else {
            genderLabel.text = "女性"
        }
        residenceLabel.text = user.sResidence
        
        if user.sBody == "" {
            bodyLabel.text = "こだわらない"
        } else {
            bodyLabel.text = user.sBody
        }
        
        if user.sBlood == "" {
            bloodLabel.text = "こだわらない"
        } else {
            bloodLabel.text = user.sBlood
        }
        
        if user.sProfession == "" {
            professionLabel.text = "こだわらない"
        } else {
            professionLabel.text = user.sProfession
        }
        
        if user.sHeight <= 129 {
            heightLabel.text = "こだわらない"
        } else {
            heightLabel.text = String(user.sHeight) + "cm〜"
        }
        
        minLabel.text = String(user.minAge)
        maxLabel.text = String(user.maxAge)
        minSlider.value = Float(user.minAge)
        maxSlider.value = Float(user.maxAge)
    }
    
    private func setupUI() {
        pickerKeyBoard1.delegate = self
        pickerKeyBoard2.delegate = self
        pickerKeyBoard3.delegate = self
        pickerKeyBoard4.delegate = self
        pickerKeyBoard6.delegate = self
        pickerKeyBoard16.delegate = self
        tableView.tableFooterView = UIView()
        navigationItem.title = "検索条件"
        doneButton.layer.cornerRadius = 44 / 2
    }
}

extension ModalSearchTableViewController: PickerKeyboard1Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard1) -> Array<String> {
        return dataArray19
    }

    func didDone(_ pickerKeyboard: PickerKeyboard1, selectData: String) {
        heightLabel2.text = selectData
        if selectData == "こだわらない" {
            heightLabel.text = "こだわらない"
        } else {
            heightLabel.text = selectData + "cm〜"
        }
    }
}

extension ModalSearchTableViewController: PickerKeyboard2Delegate {
    func titlesOfPickerViewKeyboard2(_ pickerKeyboard: PickerKeyboard2) -> Array<String> {
        return dataArray22
    }
    
    func didDone2(_ pickerKeyboard: PickerKeyboard2, selectData: String) {
        bodyLabel.text = selectData
    }
}

extension ModalSearchTableViewController: PickerKeyboard3Delegate {
    func titlesOfPickerViewKeyboard3(_ pickerKeyboard: PickerKeyboard3) -> Array<String> {
        return dataArray18
    }
    
    func didDone3(_ pickerKeyboard: PickerKeyboard3, selectData: String) {
        residenceLabel.text = selectData
    }
}

extension ModalSearchTableViewController: PickerKeyboard4Delegate {
    func titlesOfPickerViewKeyboard4(_ pickerKeyboard: PickerKeyboard4) -> Array<String> {
        return dataArray20
    }
    
    func didDone4(_ pickerKeyboard: PickerKeyboard4, selectData: String) {
        professionLabel.text = selectData
    }
}

extension ModalSearchTableViewController: PickerKeyboard6Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard6) -> Array<String> {
        return dataArray21
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard6, selectData: String) {
        bloodLabel.text = selectData
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
