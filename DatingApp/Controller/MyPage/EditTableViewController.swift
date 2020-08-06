//
//  EditTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage

class EditTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var pickerKeyboardView1: PickerKeyboard1!
    @IBOutlet weak var pickerKeyboardView2: PickerKeyboard2!
    @IBOutlet weak var pickerKeyboardView3: PickerKeyboard3!
    @IBOutlet weak var pickerKeyboardView4: PickerKeyboard4!
    @IBOutlet weak var pickerKeyboardView5: PickerKeyboard5!
    @IBOutlet weak var pickerKeyboardView6: PickerKeyboard6!
    @IBOutlet weak var pickerKeyboardView7: PickerKeyboard7!
    @IBOutlet weak var pickerKeyboardView8: PickerKeyboard8!
    @IBOutlet weak var pickerKeyboardView9: PickerKeyboard9!
    @IBOutlet weak var pickerKeyboardView10: PickerKeyboard10!
    @IBOutlet weak var pickerKeyboardView11: PickerKeyboard11!
    @IBOutlet weak var pickerKeyboardView12: PickerKeyboard12!
    @IBOutlet weak var pickerKeyboardView13: PickerKeyboard13!
    @IBOutlet weak var pickerKeyboardView14: PickerKeyboard14!
    @IBOutlet weak var pickerKeyboardView15: PickerKeyboard15!
    @IBOutlet weak var profileImageView1: UIImageView!
    @IBOutlet weak var profileImageView2: UIImageView!
    @IBOutlet weak var profileImageView3: UIImageView!
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var backView3: UIView!
    @IBOutlet weak var plusButton1: UIImageView!
    @IBOutlet weak var plusButton2: UIImageView!
    @IBOutlet weak var plusButton3: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backTextView: UIView!
    @IBOutlet weak var heightSettingLabel: UILabel!
    @IBOutlet weak var bodySizeSettingLabel: UILabel!
    @IBOutlet weak var residenceSettingLabel: UILabel!
    @IBOutlet weak var professionSettingLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var selectButton1: UIButton!
    @IBOutlet weak var selectButton2: UIButton!
    @IBOutlet weak var selectButton3: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var indicator1: UIActivityIndicatorView!
    @IBOutlet weak var indicator2: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var indicator3: UIActivityIndicatorView!
    @IBOutlet weak var bloodSetLbl: UILabel!
    @IBOutlet weak var educationalSetLbl: UILabel!
    @IBOutlet weak var marriageHistoryLbl: UILabel!
    @IBOutlet weak var marriageLbl: UILabel!
    @IBOutlet weak var childLbl1: UILabel!
    @IBOutlet weak var childLbl2: UILabel!
    @IBOutlet weak var houseMateLbl: UILabel!
    @IBOutlet weak var holidayLbl: UILabel!
    @IBOutlet weak var liquorLbl: UILabel!
    @IBOutlet weak var tobaccoLbl: UILabel!
    @IBOutlet weak var birthplaceLbl: UILabel!
    @IBOutlet weak var hobbySetLbl: UILabel!

    private var user = User()
    private let picker = UIImagePickerController()
    private var buttons = [UIButton]()
    private var imageIndex = 0
    private var profileImage1: UIImage?
    private var profileImage2: UIImage?
    private var profileImage3: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColor()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "image1")
        UserDefaults.standard.removeObject(forKey: "image2")
        UserDefaults.standard.removeObject(forKey: "image3")

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        validateTextField()
        hud.textLabel.text = "ユーザー情報を保存中..."
        hud.show(in: self.view)
        
        let dict = [SELFINTRO: textView.text,
                    COMMENT: commentTextField.text,
                    USERNAME: nameTextField.text]

        updateUser(withValue: dict as [String : Any])
        hudSetup()
    }
    
    @objc func handleSelectPhoto(_ sender: UIButton) {
        
        if sender.tag == 0 {
            UserDefaults.standard.set(true, forKey: "image1")
        } else if sender.tag == 1 {
            UserDefaults.standard.set(true, forKey: "image2")
        } else if sender.tag == 2 {
            if user.profileImageUrl2 == "" {
                hud.textLabel.text = "中央の画像から設定してください"
                hud.show(in: self.view)
                hudError()
                return
            }
            UserDefaults.standard.set(true, forKey: "image3")
        }
        settingPhoto(didSelect: sender.tag)
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(user)
            self.tableView.reloadData()
        }
    }
    
    // MARK: Save data
    
    private func saveUploadImage1() {
        guard profileImage1 != nil else { return }
        
        validateSelectButton()
        indicator1.startAnimating()
        
        Service.uploadImage(image: profileImage1!) { (imageUrl) in
            let dict = [PROFILEIMAGEURL1: imageUrl]
            updateUser(withValue: dict)
            
            self.profileImage1 = nil
            UserDefaults.standard.removeObject(forKey: "image1")
            self.indicator1.stopAnimating()
            
            hud.textLabel.text = "プロフィール画像を保存しました。"
            hud.show(in: self.view)
            hudSuccess()
            self.selectButtonIsEnabled()
        }
    }
    
    private func saveUploadImage2() {
        guard profileImage2 != nil else { return }
        
        validateSelectButton()
        indicator2.startAnimating()
        
        Service.uploadImage(image: profileImage2!) { (imageUrl) in
            let dict = [PROFILEIMAGEURL2: imageUrl]
            updateUser(withValue: dict)
            
            self.profileImage2 = nil
            UserDefaults.standard.removeObject(forKey: "image2")
            self.indicator2.stopAnimating()
            
            hud.textLabel.text = "プロフィール画像を保存しました。"
            hud.show(in: self.view)
            hudSuccess()
            self.selectButtonIsEnabled()
        }
    }
    
    private func saveUploadImage3() {
        guard profileImage3 != nil else { return }
        
        indicator3.startAnimating()
        validateSelectButton()
        
        Service.uploadImage(image: profileImage3!) { (imageUrl) in
            let dict = [PROFILEIMAGEURL3: imageUrl]
            updateUser(withValue: dict)
            
            self.profileImage3 = nil
            UserDefaults.standard.removeObject(forKey: "image3")
            self.indicator3.stopAnimating()
            
            hud.textLabel.text = "プロフィール画像を保存しました。"
            hud.show(in: self.view)
            hudSuccess()
            self.selectButtonIsEnabled()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        navigationItem.title = "プロフィール編集"
        nameTextField.delegate = self
        commentTextField.delegate = self
        picker.delegate = self
        pickerKeyboardView1.delegate = self
        pickerKeyboardView2.delegate = self
        pickerKeyboardView3.delegate = self
        pickerKeyboardView4.delegate = self
        pickerKeyboardView5.delegate = self
        pickerKeyboardView6.delegate = self
        pickerKeyboardView7.delegate = self
        pickerKeyboardView8.delegate = self
        pickerKeyboardView9.delegate = self
        pickerKeyboardView10.delegate = self
        pickerKeyboardView11.delegate = self
        pickerKeyboardView12.delegate = self
        pickerKeyboardView13.delegate = self
        pickerKeyboardView14.delegate = self
        pickerKeyboardView15.delegate = self
        
        saveButton.isEnabled = true
        profileImageView1.layer.cornerRadius = 10
        profileImageView2.layer.cornerRadius = 10
        profileImageView3.layer.cornerRadius = 10
        backView1.layer.cornerRadius = 10
        backView2.layer.cornerRadius = 10
        backView3.layer.cornerRadius = 10
        backTextView.layer .cornerRadius = 5
        
        selectButton1.layer.cornerRadius = 10
        selectButton2.layer.cornerRadius = 10
        selectButton3.layer.cornerRadius = 10
        
        selectButton1.imageView?.contentMode = .scaleAspectFill
        selectButton2.imageView?.contentMode = .scaleAspectFill
        selectButton3.imageView?.contentMode = .scaleAspectFill
        
        buttons.append(selectButton1)
        buttons.append(selectButton2)
        buttons.append(selectButton3)
        
        selectButton1.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton2.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton3.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        
        backTextView.layer.borderWidth = 1
        backTextView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    private func setupUserInfo(_ user: User) {
        
        profileImageView1.sd_setImage(with: URL(string: user.profileImageUrl1))
        profileImageView2.sd_setImage(with: URL(string: user.profileImageUrl2))
        profileImageView3.sd_setImage(with: URL(string: user.profileImageUrl3))
        
        textView.text = user.selfIntro
        commentTextField.text = user.comment
        nameTextField.text = user.username
        professionSettingLabel.text = user.profession
        residenceSettingLabel.text = user.residence
        heightSettingLabel.text = user.height
        bodySizeSettingLabel.text = user.bodySize
        bloodSetLbl.text = user.blood
        birthplaceLbl.text = user.birthplace
        educationalSetLbl.text = user.education
        marriageHistoryLbl.text = user.marriageHistory
        marriageLbl.text = user.marriage
        childLbl1.text = user.child1
        childLbl2.text = user.child2
        houseMateLbl.text = user.houseMate
        holidayLbl.text = user.holiday
        liquorLbl.text = user.liquor
        tobaccoLbl.text = user.tobacco
        
        if user.hobby1 != "" && user.hobby2 != "" && user.hobby3 != "" {
            hobbySetLbl.text = user.hobby1 + "," + user.hobby2 + ",\n" + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 13)
        } else if user.hobby1 != "" && user.hobby2 != "" {
            hobbySetLbl.text = user.hobby1 + "," + user.hobby2
            hobbySetLbl.font = UIFont.systemFont(ofSize: 15)
        } else if user.hobby2 != "" && user.hobby3 != "" {
            hobbySetLbl.text = user.hobby2 + "," + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 15)
        } else if user.hobby1 != "" && user.hobby3 != "" {
            hobbySetLbl.text = user.hobby1 + "," + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 15)
        } else if user.hobby1 != "" || user.hobby2 != "" || user.hobby3 != "" {
            hobbySetLbl.text = user.hobby1 + user.hobby2 + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 17)
        } else {
            hobbySetLbl.text = "入力する"
            hobbySetLbl.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
    private func validateTextField() {
        
        saveButton.isEnabled = false
        
        if nameTextField.text!.count > 10 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "名前は10文字以下で入力してください。"
            hud.show(in: self.view)
            hud.dismiss()
            saveButton.isEnabled = true
            return
        }
        
        if commentTextField.text!.count > 16 {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "ひとことは16文字以下で入力してください。"
            hud.show(in: self.view)
            hud.dismiss()
            saveButton.isEnabled = true
            return
        }
    }
    
    private func validateSelectButton() {
        
        selectButton1.isEnabled = false
        selectButton2.isEnabled = false
        selectButton3.isEnabled = false
    }
    
    private func selectButtonIsEnabled() {
        
        selectButton1.isEnabled = true
        selectButton2.isEnabled = true
        selectButton3.isEnabled = true
    }
    
    private func settingPhoto(didSelect index: Int) {
        
        self.imageIndex = index
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    private func setProfileImage(_ image: UIImage?) {
        buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    private func hudSetup() {
        
        hud.textLabel.text = "ユーザー情報を保存しました。"
        hud.dismiss(afterDelay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupColor() {
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            saveButton.tintColor = UIColor.white
            backButton.tintColor = UIColor.white
            plusButton1.tintColor = UIColor(named: O_PINK)
            plusButton2.tintColor = UIColor(named: O_PINK)
            plusButton3.tintColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil  {
            saveButton.tintColor = UIColor(named: O_BLACK)
            backButton.tintColor = UIColor(named: O_BLACK)
            plusButton1.tintColor = UIColor(named: O_GREEN)
            plusButton2.tintColor = UIColor(named: O_GREEN)
            plusButton3.tintColor = UIColor(named: O_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            saveButton.tintColor = UIColor(named: O_BLACK)
            backButton.tintColor = UIColor(named: O_BLACK)
            plusButton1.tintColor = UIColor.white
            plusButton2.tintColor = UIColor.white
            plusButton3.tintColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            saveButton.tintColor = UIColor.white
            backButton.tintColor = UIColor.white
            plusButton1.tintColor = UIColor(named: O_DARK)
            plusButton2.tintColor = UIColor(named: O_DARK)
            plusButton3.tintColor = UIColor(named: O_DARK)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension EditTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.editedImage] as? UIImage
        setProfileImage(selectedImage)
        
        if UserDefaults.standard.object(forKey: "image1") != nil {
            profileImage1 = selectedImage!
            saveUploadImage1()
        }
        if UserDefaults.standard.object(forKey: "image2") != nil {
            profileImage2 = selectedImage!
            saveUploadImage2()
        }
        if UserDefaults.standard.object(forKey: "image3") != nil {
            profileImage3 = selectedImage!
            saveUploadImage3()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditTableViewController: PickerKeyboard1Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard1) -> Array<String> {
        return dataArray1
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard1, selectData: String) {
        heightSettingLabel.text = selectData
        updateUser(withValue: [HEIGHT: heightSettingLabel.text as Any])
    }
}

extension EditTableViewController: PickerKeyboard2Delegate {
    func titlesOfPickerViewKeyboard2(_ pickerKeyboard: PickerKeyboard2) -> Array<String> {
        return dataArray2
    }
    
    func didDone2(_ pickerKeyboard: PickerKeyboard2, selectData: String) {
        bodySizeSettingLabel.text = selectData
        updateUser(withValue: [BODYSIZE: bodySizeSettingLabel.text as Any])
    }
}

extension EditTableViewController: PickerKeyboard3Delegate {
    func titlesOfPickerViewKeyboard3(_ pickerKeyboard: PickerKeyboard3) -> Array<String> {
        return dataArray3
    }
    
    func didDone3(_ pickerKeyboard: PickerKeyboard3, selectData: String) {
        residenceSettingLabel.text = selectData
        updateUser(withValue: [RESIDENCE: residenceSettingLabel.text as Any])
    }
}

extension EditTableViewController: PickerKeyboard4Delegate {
    func titlesOfPickerViewKeyboard4(_ pickerKeyboard: PickerKeyboard4) -> Array<String> {
        return dataArray4
    }
    
    func didDone4(_ pickerKeyboard: PickerKeyboard4, selectData: String) {
        professionSettingLabel.text = selectData
        updateUser(withValue: [PROFESSION: professionSettingLabel.text as Any])
    }
}

extension EditTableViewController: PickerKeyboard5Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard5) -> Array<String> {
        return dataArray5
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard5, selectData: String) {
        birthplaceLbl.text = selectData
        updateUser(withValue: [BIRTHPLACE: birthplaceLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard6Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard6) -> Array<String> {
        return dataArray6
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard6, selectData: String) {
        bloodSetLbl.text = selectData
        updateUser(withValue: [BLOOD: bloodSetLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard7Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard7) -> Array<String> {
        return dataArray7
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard7, selectData: String) {
        educationalSetLbl.text = selectData
        updateUser(withValue: [EDUCATION: educationalSetLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard8Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard8) -> Array<String> {
        return dataArray8
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard8, selectData: String) {
        marriageHistoryLbl.text = selectData
        updateUser(withValue: [MARRIAGEHISTORY: marriageHistoryLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard9Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard9) -> Array<String> {
        return dataArray9
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard9, selectData: String) {
        marriageLbl.text = selectData
        updateUser(withValue: [MARRIAGE: marriageLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard10Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard10) -> Array<String> {
        return dataArray10
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard10, selectData: String) {
        childLbl1.text = selectData
        updateUser(withValue: [CHILD1: childLbl1.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard11Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard11) -> Array<String> {
        return dataArray11
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard11, selectData: String) {
        childLbl2.text = selectData
        updateUser(withValue: [CHILD2: childLbl2.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard12Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard12) -> Array<String> {
        return dataArray12
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard12, selectData: String) {
        houseMateLbl.text = selectData
        updateUser(withValue: [HOUSEMATE: houseMateLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard13Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard13) -> Array<String> {
        return dataArray13
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard13, selectData: String) {
        holidayLbl.text = selectData
        updateUser(withValue: [HOLIDAY: holidayLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard14Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard14) -> Array<String> {
        return dataArray14
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard14, selectData: String) {
        liquorLbl.text = selectData
        updateUser(withValue: [LIQUOR: liquorLbl.text as Any])
    }
}
extension EditTableViewController: PickerKeyboard15Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard15) -> Array<String> {
        return dataArray15
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard15, selectData: String) {
        tobaccoLbl.text = selectData
        updateUser(withValue: [TOBACCO: tobaccoLbl.text as Any])
    }
}
