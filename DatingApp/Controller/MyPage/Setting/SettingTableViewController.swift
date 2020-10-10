//
//  SettingTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class SettingTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var completionButton: UIBarButtonItem!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minSlider: UISlider!
    @IBOutlet weak var maxSlider: UISlider!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var pickerKeyboard: PickerKeyboard3!
    @IBOutlet weak var footstepSwitch: UISwitch!
    @IBOutlet weak var footstepLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var readSwitch: UISwitch!
    @IBOutlet weak var keyImaegView: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var keyImageView2: UIImageView!
    
    private var user = User()
    
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
    
    @IBAction func footstepSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: FOOTSTEP_ON)
            footstepLabel.text = "足あとを残す"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: FOOTSTEP_ON)
            footstepLabel.text = "足あとを残さない"
        }
    }
    
    
    @IBAction func readSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: ISREAD_ON)
            readLabel.text = "既読表示をする"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: ISREAD_ON)
            readLabel.text = "既読表示をしない"
        }
    }
    
    @IBAction func distanceSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: DISTANCE_ON)
            distanceLabel.text = "距離表示をする"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: DISTANCE_ON)
            distanceLabel.text = "距離表示をしない"
        }
    }
    
    @IBAction func completionButtonPressed(_ sender: Any) {
        
        let dict = [MINAGE: Int(minLabel.text!)!,
                    MAXAGE: Int(maxLabel.text!)!,
                    S_RESIDENCE: residenceLabel.text!] as [String : Any]
        
        if residenceLabel.text == "こだわらない" {
            UserDefaults.standard.set(true, forKey: ALL)
        } else {
            UserDefaults.standard.removeObject(forKey: ALL)
        }
        
        updateUser(withValue: dict as [String : Any])
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapKeyImageView() {
        
        let alert = UIAlertController(title: "", message: "ショップのアイテム(透視)を使用することで機能解放できます", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確認", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapKeyImageView2() {
        
        let alert = UIAlertController(title: "", message: "全てのミッションクリアで機能解放できます", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "確認", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        guard Auth.auth().currentUser != nil else { return }
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(user)
        }
    }
    
    //MARK: - logout
    
    private func logoutUser() {
        
        let alert = UIAlertController(title: "", message: "ログアウトしてもよろしいですか？", preferredStyle: .actionSheet)
        let logout = UIAlertAction(title: "ログアウト", style: UIAlertAction.Style.default) { (alert) in
            
            AuthService.logoutUser { (error) in
                if error != nil {
                    print("error logout user: \(error!.localizedDescription)")
                } else {
                    self.toSelectLoginVC()
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Withdraw
    
    private func withdraw() {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "退会するとプロフィール情報がすべて削除されます。\n元に戻すことはできません。", preferredStyle: .actionSheet)
        let logout: UIAlertAction = UIAlertAction(title: "退会を進める", style: UIAlertAction.Style.default) { (alert) in
            self.toWithdrawVC()
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    // MARK: - Helpers
    
    private func setupUserInfo(_ user: User) {
        
        minLabel.text = String(user.minAge)
        maxLabel.text = String(user.maxAge)
        minSlider.value = Float(user.minAge)
        maxSlider.value = Float(user.maxAge)
        residenceLabel.text = user.sResidence
        
        if user.usedItem8 == 1 {
            keyImaegView.isHidden = true
            readSwitch.isHidden = false
        } else {
            keyImaegView.isHidden = false
            readSwitch.isHidden = true
        }
        
        if user.usedItem7 == 1 {
            keyImageView2.isHidden = true
            distanceSwitch.isHidden = false
        } else {
            keyImageView2.isHidden = false
            distanceSwitch.isHidden = true
        }
    }
    
    private func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapKeyImageView))
        keyImaegView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapKeyImageView2))
        keyImageView2.addGestureRecognizer(tap2)
        
        pickerKeyboard.delegate = self
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!], for: .normal)
        genderLabel.text = ""
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
        navigationItem.title = "設定"
        
        if UserDefaults.standard.object(forKey: FOOTSTEP_ON) != nil {
            footstepSwitch.isOn = true
            footstepLabel.text = "足あとを残す"
        } else {
            footstepSwitch.isOn = false
            footstepLabel.text = "足あとを残さない"
        }
        
        if UserDefaults.standard.object(forKey: ISREAD_ON) != nil {
            readSwitch.isOn = true
            readLabel.text = "既読表示をする"
        } else {
            readSwitch.isOn = false
            readLabel.text = "既読表示をしない"
        }
        
        if UserDefaults.standard.object(forKey: DISTANCE_ON) != nil {
            distanceSwitch.isOn = true
            distanceLabel.text = "距離表示をする"
        } else {
            distanceSwitch.isOn = false
            distanceLabel.text = "距離表示をしない"
        }
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            genderLabel.text = "男性"
        } else {
            genderLabel.text = "女性"
        }
    }
    
    private func toSelectLoginVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
        self.present(toSelectLoginVC, animated: true, completion: nil)
    }
    
    private func toWithdrawVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toWithdrawVC = storyboard.instantiateViewController(withIdentifier: "WithdrawVC")
        self.present(toWithdrawVC, animated: true, completion: nil)
    }
    
    private func toChangeEmailVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toChangeEmailVC = storyboard.instantiateViewController(withIdentifier: "ChangeEmailVC")
        self.present(toChangeEmailVC, animated: true, completion: nil)
    }
    
    private func toChangePasswordVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toChangePasswordVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC")
        self.present(toChangePasswordVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 6 && indexPath.row == 0 {
            toChangeEmailVC()
        } else if indexPath.section == 6 && indexPath.row == 1 {
            toChangePasswordVC()
        } else if indexPath.section == 7 && indexPath.row == 4 {
            withdraw()
        } else if indexPath.section == 8 {
            logoutUser()
        }
    }
}

extension SettingTableViewController: PickerKeyboard3Delegate {
    func titlesOfPickerViewKeyboard3(_ pickerKeyboard: PickerKeyboard3) -> Array<String> {
        return dataArray18
    }
    
    func didDone3(_ pickerKeyboard: PickerKeyboard3, selectData: String) {
        residenceLabel.text = selectData
    }
}
