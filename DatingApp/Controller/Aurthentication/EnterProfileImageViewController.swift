//
//  EnterProfileImageViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterProfileImageViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    private var user: User!
    private let picker = UIImagePickerController()
    private var profileImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUser()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if profileImage == nil {
            hud.textLabel.text = "プロフィール画像を設定してください。"
            hud.show(in: self.view)
            hudError()
            return
        }
        nextButton.isEnabled = false
        saveProfileImage()
    }
    
    @IBAction func profileImageTaped(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - User
    
    private func loadUser() {
        
        fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    private func saveProfileImage() {
        indicator.startAnimating()
        
        Service.uploadImage(image: profileImage!) { (imageUrl) in
            
            let user = User()
            user.uid = self.user.uid
            user.profileImageUrls = [String(imageUrl)]
            
            updateUserData2(user)
            hud.textLabel.text = "保存が成功しました。"
            self.indicator.stopAnimating()
            hud.show(in: self.view)
            hudSuccess()
            self.toEnterProfessionVC()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        picker.delegate = self
        descriptionLabel.text = "プロフィール画像を設定してください。\nあとで設定することもできます。"
        nextButton.layer.cornerRadius = 50 / 2
        skipButton.layer.cornerRadius = 50 / 2
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        profileImageView.layer.cornerRadius = 150 / 2
    }
    
    // MARK: - Navigation

    private func toEnterProfessionVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterProfessionVC = storyboard.instantiateViewController(withIdentifier: "EnterProfessionVC")
            self.present(toEnterProfessionVC, animated: true, completion: nil)
        }
    }
    
}

extension EnterProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            profileImageView.image = selectedImage
            profileImage = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
