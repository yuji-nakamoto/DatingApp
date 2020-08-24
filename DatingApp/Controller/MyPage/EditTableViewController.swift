//
//  EditTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD

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
    @IBOutlet weak var profileImageView4: UIImageView!
    @IBOutlet weak var profileImageView5: UIImageView!
    @IBOutlet weak var profileImageView6: UIImageView!
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var backView3: UIView!
    @IBOutlet weak var backView4: UIView!
    @IBOutlet weak var backView5: UIView!
    @IBOutlet weak var backView6: UIView!
    @IBOutlet weak var heightSettingLabel: UILabel!
    @IBOutlet weak var bodySizeSettingLabel: UILabel!
    @IBOutlet weak var residenceSettingLabel: UILabel!
    @IBOutlet weak var professionSettingLabel: UILabel!
    @IBOutlet weak var selectButton1: UIButton!
    @IBOutlet weak var selectButton2: UIButton!
    @IBOutlet weak var selectButton3: UIButton!
    @IBOutlet weak var selectButton4: UIButton!
    @IBOutlet weak var selectButton5: UIButton!
    @IBOutlet weak var selectButton6: UIButton!
    @IBOutlet weak var indicator1: UIActivityIndicatorView!
    @IBOutlet weak var indicator2: UIActivityIndicatorView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var indicator3: UIActivityIndicatorView!
    @IBOutlet weak var indicator4: UIActivityIndicatorView!
    @IBOutlet weak var indicator5: UIActivityIndicatorView!
    @IBOutlet weak var indicator6: UIActivityIndicatorView!
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
    @IBOutlet weak var commentSetLbl: UILabel!
    @IBOutlet weak var nicknameSetLbl: UILabel!
    @IBOutlet weak var selfIntroLabl: UILabel!
    @IBOutlet weak var selfIntroSetLbl: UILabel!
    @IBOutlet weak var detailMapSetLbl: UILabel!
    @IBOutlet weak var plusImageView2: UIImageView!
    @IBOutlet weak var plusImageView3: UIImageView!
    @IBOutlet weak var plusImageView4: UIImageView!
    @IBOutlet weak var plusImageView5: UIImageView!
    @IBOutlet weak var plusImageView6: UIImageView!
 
    private var user = User()
    private let picker = UIImagePickerController()
    private var buttons = [UIButton]()
    private var imageIndex = 0
    private var profileImage1: UIImage?
    private var profileImage2: UIImage?
    private var profileImage3: UIImage?
    private var profileImage4: UIImage?
    private var profileImage5: UIImage?
    private var profileImage6: UIImage?
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        setupUI()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSelectPhoto(_ sender: UIButton) {
        
        if sender.tag == 0 {
            UserDefaults.standard.set(true, forKey: "image1")
            UserDefaults.standard.removeObject(forKey: "image2")
            UserDefaults.standard.removeObject(forKey: "image3")
            UserDefaults.standard.removeObject(forKey: "image4")
            UserDefaults.standard.removeObject(forKey: "image5")
            UserDefaults.standard.removeObject(forKey: "image6")
        } else if sender.tag == 1 {
            UserDefaults.standard.set(true, forKey: "image2")
            UserDefaults.standard.removeObject(forKey: "image1")
            UserDefaults.standard.removeObject(forKey: "image3")
            UserDefaults.standard.removeObject(forKey: "image4")
            UserDefaults.standard.removeObject(forKey: "image5")
            UserDefaults.standard.removeObject(forKey: "image6")
        } else if sender.tag == 2 {
            UserDefaults.standard.set(true, forKey: "image3")
            UserDefaults.standard.removeObject(forKey: "image2")
            UserDefaults.standard.removeObject(forKey: "image1")
            UserDefaults.standard.removeObject(forKey: "image4")
            UserDefaults.standard.removeObject(forKey: "image5")
            UserDefaults.standard.removeObject(forKey: "image6")
        } else if sender.tag == 3 {
            UserDefaults.standard.set(true, forKey: "image4")
            UserDefaults.standard.removeObject(forKey: "image2")
            UserDefaults.standard.removeObject(forKey: "image3")
            UserDefaults.standard.removeObject(forKey: "image1")
            UserDefaults.standard.removeObject(forKey: "image5")
            UserDefaults.standard.removeObject(forKey: "image6")
        } else if sender.tag == 4 {
            UserDefaults.standard.set(true, forKey: "image5")
            UserDefaults.standard.removeObject(forKey: "image2")
            UserDefaults.standard.removeObject(forKey: "image3")
            UserDefaults.standard.removeObject(forKey: "image4")
            UserDefaults.standard.removeObject(forKey: "image1")
            UserDefaults.standard.removeObject(forKey: "image6")
        } else if sender.tag == 5 {
            UserDefaults.standard.set(true, forKey: "image6")
            UserDefaults.standard.removeObject(forKey: "image2")
            UserDefaults.standard.removeObject(forKey: "image3")
            UserDefaults.standard.removeObject(forKey: "image4")
            UserDefaults.standard.removeObject(forKey: "image5")
            UserDefaults.standard.removeObject(forKey: "image1")
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
            
            self.hud.textLabel.text = "プロフィール画像を保存しました。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
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
            
            self.hud.textLabel.text = "プロフィール画像を保存しました。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            self.fetchUser()
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
            
            self.hud.textLabel.text = "プロフィール画像を保存しました。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            self.fetchUser()
            self.selectButtonIsEnabled()
        }
    }
    
    private func saveUploadImage4() {
        guard profileImage4 != nil else { return }
        
        indicator4.startAnimating()
        validateSelectButton()
        
        Service.uploadImage(image: profileImage4!) { (imageUrl) in
            let dict = [PROFILEIMAGEURL4: imageUrl]
            updateUser(withValue: dict)
            
            self.profileImage4 = nil
            UserDefaults.standard.removeObject(forKey: "image4")
            self.indicator4.stopAnimating()
            
            self.hud.textLabel.text = "プロフィール画像を保存しました。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            self.fetchUser()
            self.selectButtonIsEnabled()
        }
    }
    
    private func saveUploadImage5() {
        guard profileImage5 != nil else { return }
        
        indicator5.startAnimating()
        validateSelectButton()
        
        Service.uploadImage(image: profileImage5!) { (imageUrl) in
            let dict = [PROFILEIMAGEURL5: imageUrl]
            updateUser(withValue: dict)
            
            self.profileImage5 = nil
            UserDefaults.standard.removeObject(forKey: "image5")
            self.indicator5.stopAnimating()
            
            self.hud.textLabel.text = "プロフィール画像を保存しました。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            self.fetchUser()
            self.selectButtonIsEnabled()
        }
    }
    
    private func saveUploadImage6() {
        guard profileImage6 != nil else { return }
        
        indicator6.startAnimating()
        validateSelectButton()
        
        Service.uploadImage(image: profileImage6!) { (imageUrl) in
            let dict = [PROFILEIMAGEURL6: imageUrl]
            updateUser(withValue: dict)
            
            self.profileImage6 = nil
            UserDefaults.standard.removeObject(forKey: "image6")
            self.indicator6.stopAnimating()
            
            self.hud.textLabel.text = "プロフィール画像を保存しました。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            self.selectButtonIsEnabled()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        navigationItem.title = "プロフィール編集"
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
        
        profileImageView1.layer.cornerRadius = 10
        profileImageView2.layer.cornerRadius = 10
        profileImageView3.layer.cornerRadius = 10
        profileImageView4.layer.cornerRadius = 10
        profileImageView5.layer.cornerRadius = 10
        profileImageView6.layer.cornerRadius = 10
        
        backView1.layer.cornerRadius = 10
        backView2.layer.cornerRadius = 10
        backView3.layer.cornerRadius = 10
        backView4.layer.cornerRadius = 10
        backView5.layer.cornerRadius = 10
        backView6.layer.cornerRadius = 10

        selectButton1.layer.cornerRadius = 10
        selectButton2.layer.cornerRadius = 10
        selectButton3.layer.cornerRadius = 10
        selectButton4.layer.cornerRadius = 10
        selectButton5.layer.cornerRadius = 10
        selectButton6.layer.cornerRadius = 10
        
        selectButton1.imageView?.contentMode = .scaleAspectFill
        selectButton2.imageView?.contentMode = .scaleAspectFill
        selectButton3.imageView?.contentMode = .scaleAspectFill
        selectButton4.imageView?.contentMode = .scaleAspectFill
        selectButton5.imageView?.contentMode = .scaleAspectFill
        selectButton6.imageView?.contentMode = .scaleAspectFill
        
        buttons.append(selectButton1)
        buttons.append(selectButton2)
        buttons.append(selectButton3)
        buttons.append(selectButton4)
        buttons.append(selectButton5)
        buttons.append(selectButton6)
        
        selectButton1.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton2.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton3.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton4.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton5.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        selectButton6.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        
        plusImageView2.isHidden = true
        plusImageView3.isHidden = true
        plusImageView4.isHidden = true
        plusImageView5.isHidden = true
        plusImageView6.isHidden = true
    }
    
    private func setupUserInfo(_ user: User) {
        
        profileImageView1.sd_setImage(with: URL(string: user.profileImageUrl1))
        profileImageView2.sd_setImage(with: URL(string: user.profileImageUrl2))
        profileImageView3.sd_setImage(with: URL(string: user.profileImageUrl3))
        profileImageView4.sd_setImage(with: URL(string: user.profileImageUrl4))
        profileImageView5.sd_setImage(with: URL(string: user.profileImageUrl5))
        profileImageView6.sd_setImage(with: URL(string: user.profileImageUrl6))
        
        residenceSettingLabel.text = user.residence
        residenceSettingLabel.textColor = UIColor(named: O_GREEN)
        
        if user.profession == "" {
            professionSettingLabel.text = "設定する"
            bodySizeSettingLabel.textColor = .systemGray
        } else {
            professionSettingLabel.text = user.profession
            professionSettingLabel.textColor = UIColor(named: O_GREEN)
        }
        
        if user.selfIntro != "" {
            selfIntroLabl.text = user.selfIntro
            selfIntroLabl.isHidden = false
            selfIntroSetLbl.isHidden = true
        } else {
            selfIntroLabl.text = "自己紹介"
            selfIntroSetLbl.isHidden = false
        }

        if user.height != "未設定" {
            heightSettingLabel.text = user.height
            heightSettingLabel.textColor = UIColor(named: O_GREEN)
        } else {

            heightSettingLabel.textColor = .systemGray
        }
        
        if user.bodySize != "未設定" {
            bodySizeSettingLabel.text = user.bodySize
            bodySizeSettingLabel.textColor = UIColor(named: O_GREEN)
        } else {
            bodySizeSettingLabel.textColor = .systemGray
        }
        
        if user.blood != "未設定" {
            bloodSetLbl.text = user.blood
            bloodSetLbl.textColor = UIColor(named: O_GREEN)
        } else {
            bloodSetLbl.textColor = .systemGray
        }
        
        if user.birthplace != "未設定" {
            birthplaceLbl.text = user.birthplace
            birthplaceLbl.textColor = UIColor(named: O_GREEN)
        } else {
            birthplaceLbl.textColor = .systemGray
        }
        
        if user.education != "未設定" {
            educationalSetLbl.text = user.education
            educationalSetLbl.textColor = UIColor(named: O_GREEN)
        } else {
            educationalSetLbl.textColor = .systemGray
        }
        
        if user.marriageHistory != "未設定" {
            marriageHistoryLbl.text = user.marriageHistory
            marriageHistoryLbl.textColor = UIColor(named: O_GREEN)
        } else {
            marriageHistoryLbl.textColor = .systemGray
        }
        
        if user.marriage != "未設定" {
            marriageLbl.text = user.marriage
            marriageLbl.textColor = UIColor(named: O_GREEN)
        } else {
            marriageLbl.textColor = .systemGray
        }
        
        if user.child1 != "未設定" {
            childLbl1.text = user.child1
            childLbl1.textColor = UIColor(named: O_GREEN)
        } else {
            childLbl1.textColor = .systemGray
        }
        
        if user.child2 != "未設定" {
            childLbl2.text = user.child2
            childLbl2.textColor = UIColor(named: O_GREEN)
        } else {
            childLbl2.textColor = .systemGray
        }
        
        if user.houseMate != "未設定" {
            houseMateLbl.text = user.houseMate
            houseMateLbl.textColor = UIColor(named: O_GREEN)
        } else {
            houseMateLbl.textColor = .systemGray
        }
        
        if user.holiday != "未設定" {
            holidayLbl.text = user.holiday
            holidayLbl.textColor = UIColor(named: O_GREEN)
        } else {
            holidayLbl.textColor = .systemGray
        }
        
        if user.liquor != "未設定" {
            liquorLbl.text = user.liquor
            liquorLbl.textColor = UIColor(named: O_GREEN)
        } else {
            liquorLbl.textColor = .systemGray
        }
        
        if user.tobacco != "未設定" {
            tobaccoLbl.text = user.tobacco
            tobaccoLbl.textColor = UIColor(named: O_GREEN)
        } else {
            tobaccoLbl.textColor = .systemGray
        }
        
        nicknameSetLbl.text = user.username
        
        if user.comment != "" {
            commentSetLbl.text = user.comment
        } else {
            commentSetLbl.text = "入力する"
        }
        
        if user.detailArea != "" {
            detailMapSetLbl.text = user.detailArea
            detailMapSetLbl.textColor = UIColor(named: O_GREEN)
        } else {
            detailMapSetLbl.textColor = .systemGray
            detailMapSetLbl.text = "入力する"
        }
        
        if user.hobby1 != "" && user.hobby2 != "" && user.hobby3 != "" {
            hobbySetLbl.text = user.hobby1 + "," + user.hobby2 + ",\n" + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 13)
            hobbySetLbl.textColor = UIColor(named: O_GREEN)
        } else if user.hobby1 != "" && user.hobby2 != "" {
            hobbySetLbl.text = user.hobby1 + "," + user.hobby2
            hobbySetLbl.font = UIFont.systemFont(ofSize: 15)
            hobbySetLbl.textColor = UIColor(named: O_GREEN)
        } else if user.hobby2 != "" && user.hobby3 != "" {
            hobbySetLbl.text = user.hobby2 + "," + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 15)
            hobbySetLbl.textColor = UIColor(named: O_GREEN)
        } else if user.hobby1 != "" && user.hobby3 != "" {
            hobbySetLbl.text = user.hobby1 + "," + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 15)
            hobbySetLbl.textColor = UIColor(named: O_GREEN)
        } else if user.hobby1 != "" || user.hobby2 != "" || user.hobby3 != "" {
            hobbySetLbl.text = user.hobby1 + user.hobby2 + user.hobby3
            hobbySetLbl.font = UIFont.systemFont(ofSize: 17)
            hobbySetLbl.textColor = UIColor(named: O_GREEN)
        } else {
            hobbySetLbl.text = "入力する"
            hobbySetLbl.font = UIFont.systemFont(ofSize: 17)
            hobbySetLbl.textColor = .systemGray
        }
        
        if user.profileImageUrl2 == "" {
            selectButton3.isEnabled = false
            selectButton4.isEnabled = false
            selectButton5.isEnabled = false
            selectButton6.isEnabled = false
            plusImageView2.isHidden = false
            backView2.backgroundColor = UIColor(named: O_GREEN)
        } else if user.profileImageUrl3 == "" {
            selectButton3.isEnabled = true
            selectButton4.isEnabled = false
            selectButton5.isEnabled = false
            selectButton6.isEnabled = false
            plusImageView2.isHidden = true
            plusImageView3.isHidden = false
            backView3.backgroundColor = UIColor(named: O_GREEN)
        } else if user.profileImageUrl4 == "" {
            selectButton4.isEnabled = true
            selectButton5.isEnabled = false
            selectButton6.isEnabled = false
            plusImageView3.isHidden = true
            plusImageView4.isHidden = false
            backView4.backgroundColor = UIColor(named: O_GREEN)
        } else if user.profileImageUrl5 == "" {
            selectButton5.isEnabled = true
            selectButton6.isEnabled = false
            plusImageView4.isHidden = true
            plusImageView5.isHidden = false
            backView5.backgroundColor = UIColor(named: O_GREEN)
        } else if user.profileImageUrl6 == "" {
            selectButton6.isEnabled = true
            plusImageView5.isHidden = true
            plusImageView6.isHidden = false
            backView6.backgroundColor = UIColor(named: O_GREEN)
        }
    }
    
    private func validateSelectButton() {
        
        selectButton1.isEnabled = false
        selectButton2.isEnabled = false
        selectButton3.isEnabled = false
        selectButton4.isEnabled = false
        selectButton5.isEnabled = false
        selectButton6.isEnabled = false
    }
    
    private func selectButtonIsEnabled() {
        
        selectButton1.isEnabled = true
        selectButton2.isEnabled = true
        selectButton3.isEnabled = true
        selectButton4.isEnabled = true
        selectButton5.isEnabled = true
        selectButton6.isEnabled = true
    }
    
    private func settingPhoto(didSelect index: Int) {
        
        self.imageIndex = index
        alertCamera()
    }
    
    private func setProfileImage(_ image: UIImage?) {
        buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func alertCamera() {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "選択してください", preferredStyle: .actionSheet)
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラで撮影", style: .default, handler:{ [weak self]
                (action: UIAlertAction!) -> Void in
            guard let this = self else { return }
            let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let cameraPicker = UIImagePickerController()
                cameraPicker.sourceType = sourceType
                cameraPicker.delegate = this
                cameraPicker.allowsEditing = true
                this.present(cameraPicker, animated: true, completion: nil)
            }
        })
        
        let galleryAction: UIAlertAction = UIAlertAction(title: "アルバムから選択", style: .default, handler:{ [weak self]
            (action: UIAlertAction!) -> Void in
            guard let this = self else { return }
            let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let libraryPicker = UIImagePickerController()
                libraryPicker.sourceType = sourceType
                libraryPicker.delegate = this
                libraryPicker.allowsEditing = true
                this.present(libraryPicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        present(alert, animated: true, completion: nil)
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
            backButton.tintColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: GREEN) != nil  {
            backButton.tintColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            backButton.tintColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            backButton.tintColor = UIColor.white
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
        if UserDefaults.standard.object(forKey: "image4") != nil {
            profileImage4 = selectedImage!
            saveUploadImage4()
        }
        if UserDefaults.standard.object(forKey: "image5") != nil {
            profileImage5 = selectedImage!
            saveUploadImage5()
        }
        if UserDefaults.standard.object(forKey: "image6") != nil {
            profileImage6 = selectedImage!
            saveUploadImage6()
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
