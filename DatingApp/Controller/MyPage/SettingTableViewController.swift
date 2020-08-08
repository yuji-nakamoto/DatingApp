//
//  SettingTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

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
    
    @IBAction func footstepSwitch(_ sender: UISwitch) {
        
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

    @IBAction func completionButtonPressed(_ sender: Any) {
        
        let dict = [MINAGE: Int(minLabel.text!)!,
                    MAXAGE: Int(maxLabel.text!)!,
                    RESIDENCESEARCH: residenceLabel.text!] as [String : Any]
        
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
                }
                self.toSelectLoginVC()
            }
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
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            genderLabel.text = "男性"
        } else {
            genderLabel.text = "女性"
        }
    }
    
    private func toSelectLoginVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
            self.present(toSelectLoginVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 4 {
            logoutUser()
        }
    }

}

extension SettingTableViewController: PickerKeyboard3Delegate {
    func titlesOfPickerViewKeyboard3(_ pickerKeyboard: PickerKeyboard3) -> Array<String> {
        return dataArray3
    }
    
    func didDone3(_ pickerKeyboard: PickerKeyboard3, selectData: String) {
        residenceLabel.text = selectData
    }
}
