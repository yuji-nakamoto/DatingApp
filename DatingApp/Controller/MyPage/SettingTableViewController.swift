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
    @IBOutlet weak var likeSwitch: UISwitch!
    @IBOutlet weak var typeSwitch: UISwitch!
    @IBOutlet weak var messageSwitch: UISwitch!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var matchSwitch: UISwitch!
    

    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerKeyboard.delegate = self
        setupUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
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
    
    @IBAction func likeSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: LIKE_ON)
            Messaging.messaging().subscribe(toTopic: "like\(Auth.auth().currentUser!.uid)")
            likeLabel.text = "いいね通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: LIKE_ON)
            Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
            likeLabel.text = "いいね通知を受信しない"
        }
    }
    
    @IBAction func typeSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: TYPE_ON)
            Messaging.messaging().subscribe(toTopic: "type\(Auth.auth().currentUser!.uid)")
            typeLabel.text = "タイプ通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: TYPE_ON)
            Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
            typeLabel.text = "タイプ通知を受信しない"
        }
    }
    
    @IBAction func messageSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: MESSAGE_ON)
            Messaging.messaging().subscribe(toTopic: "message\(Auth.auth().currentUser!.uid)")
            messageLabel.text = "メッセージ通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: MESSAGE_ON)
            Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
            messageLabel.text = "メッセージ通知を受信しない"
        }
    }
    
    @IBAction func matchSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: MATCH_ON)
            Messaging.messaging().subscribe(toTopic: "match\(Auth.auth().currentUser!.uid)")
            matchLabel.text = "マッチング通知を受信する"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: MATCH_ON)
            Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")
            matchLabel.text = "マッチング通知を受信しない"
        }
    }

    @IBAction func completionButtonPressed(_ sender: Any) {
        
        let dict = [MINAGE: Int(minLabel.text!)!,
                    MAXAGE: Int(maxLabel.text!)!,
                    RESIDENCESEARCH: residenceLabel.text!] as [String : Any]
        
        if residenceLabel.text == "こだわらない" {
            UserDefaults.standard.set(true, forKey: ALL)
        } else {
            UserDefaults.standard.removeObject(forKey: ALL)
        }
        
        updateUser(withValue: dict as [String : Any])
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(user)
        }
    }
    
    //MARK: - logout
    
    private func logoutUser() {
        
        let alert: UIAlertController = UIAlertController(title: user.username, message: "ログアウトしてもよろしいですか？", preferredStyle: .actionSheet)
        let logout: UIAlertAction = UIAlertAction(title: "ログアウト", style: UIAlertAction.Style.default) { (alert) in
            
            AuthService.logoutUser { (error) in
                if error != nil {
                    print("error logout user: \(error!.localizedDescription)")
                } else {
                    self.toSelectLoginVC()
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    // MARK: - Withdraw
    
    private func withdraw() {
        
        let alert: UIAlertController = UIAlertController(title: user.username, message: "退会するとアカウント・プロフィール情報がすべて削除されます。\n元に戻すことはできません。", preferredStyle: .actionSheet)
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
        residenceLabel.text = user.residenceSerch
    }
    
    private func setupUI() {
        
        genderLabel.text = ""
        navigationItem.title = "設定"
        
        if UserDefaults.standard.object(forKey: FOOTSTEP_ON) != nil {
            footstepSwitch.isOn = true
            footstepLabel.text = "足あとを残す"
        } else {
            footstepSwitch.isOn = false
            footstepLabel.text = "足あとを残さない"
        }
        
        if UserDefaults.standard.object(forKey: LIKE_ON) != nil {
            likeSwitch.isOn = true
            likeLabel.text = "いいね通知を受信する"
        } else {
            likeSwitch.isOn = false
            likeLabel.text = "いいね通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: TYPE_ON) != nil {
            typeSwitch.isOn = true
            typeLabel.text = "タイプ通知を受信する"
        } else {
            typeSwitch.isOn = false
            typeLabel.text = "タイプ通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: MESSAGE_ON) != nil {
            messageSwitch.isOn = true
            messageLabel.text = "メッセージ通知を受信する"
        } else {
            messageSwitch.isOn = false
            messageLabel.text = "メッセージ通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: MATCH_ON) != nil {
            matchSwitch.isOn = true
            matchLabel.text = "マッチング通知を受信する"
        } else {
            matchSwitch.isOn = false
            matchLabel.text = "マッチング通知を受信しない"
        }
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
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

        if indexPath.section == 5 && indexPath.row == 0 {
            toChangeEmailVC()
        } else if indexPath.section == 5 && indexPath.row == 1 {
            toChangePasswordVC()
        } else if indexPath.section == 6 && indexPath.row == 3 {
            withdraw()
        } else if indexPath.section == 7 {
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
