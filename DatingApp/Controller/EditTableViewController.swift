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
        
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
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
        
        hud.textLabel.text = "ユーザー情報を保存中..."
        hud.show(in: self.view)
        let user = User()
        user.uid = User.currentUserId()
        user.selfIntro = textView.text
        user.comment = commentTextField.text
        user.username = nameTextField.text
        user.residence = residenceSettingLabel.text
        user.profession = professionSettingLabel.text
        updateUserData2(user)
        
        if profileImage1 != nil {
            saveUploadImage1()
        } else if profileImage2 != nil {
            saveUploadImage2()
        } else if profileImage3 != nil {
            saveUploadImage3()
        }
        hudSetup()
    }
    
    @objc func handleSelectPhoto(_ sender: UIButton) {
        
        if sender.tag == 0 {
            UserDefaults.standard.set(true, forKey: "image1")
        } else if sender.tag == 1 {
            UserDefaults.standard.set(true, forKey: "image2")
        } else if sender.tag == 2 {
            UserDefaults.standard.set(true, forKey: "image3")
        }
        settingPhoto(didSelect: sender.tag)
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUI(user)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI(_ user: User) {
        
        nameTextField.delegate = self
        commentTextField.delegate = self
        picker.delegate = self
        
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
        
        profileImageView1.sd_setImage(with: URL(string: user.profileImageUrl1))
        profileImageView2.sd_setImage(with: URL(string: user.profileImageUrl2))
        profileImageView3.sd_setImage(with: URL(string: user.profileImageUrl3))
        
        backTextView.layer.borderWidth = 1
        backTextView.layer.borderColor = UIColor.systemGray.cgColor
        textView.text = user.selfIntro
        commentTextField.text = user.comment
        nameTextField.text = user.username
        professionSettingLabel.text = user.profession
        residenceSettingLabel.text = user.residence
    }
    
    private func saveUploadImage1() {
        
        Service.uploadImage(image: profileImage1!) { (imageUrl) in
            self.user.profileImageUrl1 = imageUrl
            self.user.profileImageUrl2 = self.user.profileImageUrl2
            self.user.profileImageUrl3 = self.user.profileImageUrl3
            updateProfileImageData(self.user) { (error) in
                self.hudSetup()
            }
        }
    }
    
    private func saveUploadImage2() {
        
        Service.uploadImage(image: profileImage2!) { (imageUrl) in
            self.user.profileImageUrl1 = self.user.profileImageUrl1
            self.user.profileImageUrl2 = imageUrl
            self.user.profileImageUrl3 = self.user.profileImageUrl3
            updateProfileImageData(self.user) { (error) in
                self.hudSetup()
            }
        }

    }
    
    private func saveUploadImage3() {
        
        Service.uploadImage(image: profileImage3!) { (imageUrl) in
            self.user.profileImageUrl1 = self.user.profileImageUrl1
            self.user.profileImageUrl2 = self.user.profileImageUrl2
            self.user.profileImageUrl3 = imageUrl
            updateProfileImageData(self.user) { (error) in
                self.hudSetup()
            }
        }
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
        
        UserDefaults.standard.removeObject(forKey: "image1")
        UserDefaults.standard.removeObject(forKey: "image2")
        UserDefaults.standard.removeObject(forKey: "image3")
        hud.textLabel.text = "ユーザー情報を保存しました。"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            hud.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension EditTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.editedImage] as? UIImage
        setProfileImage(selectedImage)
        
        if UserDefaults.standard.object(forKey: "image1") != nil {
            profileImage1 = selectedImage!
        } else if UserDefaults.standard.object(forKey: "image2") != nil {
            profileImage2 = selectedImage!
        } else if UserDefaults.standard.object(forKey: "image3") != nil {
            profileImage3 = selectedImage!
        }

        dismiss(animated: true, completion: nil)
    }
}
