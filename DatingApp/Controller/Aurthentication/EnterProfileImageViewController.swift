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
    
    @IBOutlet weak var anyLabel: UILabel!
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

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nextButton.isEnabled = true
        skipButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if profileImage == nil {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "プロフィール画像を設定してください。"
            hud.show(in: self.view)
            hudError()
            return
        }
        nextButton.isEnabled = false
        skipButton.isEnabled = false
        saveProfileImage()
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        addPlaceholederImage()
        skipButton.isEnabled = false
        nextButton.isEnabled = false
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
    
    private func saveProfileImage() {
        indicator.startAnimating()
        
        Service.uploadImage(image: profileImage!) { (imageUrl) in
            
            let dict = [PROFILEIMAGEURL1: imageUrl,
                        PROFILEIMAGEURL2: "",
                        PROFILEIMAGEURL3: ""]
            
            updateUser(withValue: dict)
            self.hudSetup()
        }
    }
    
    private func addPlaceholederImage() {
        
        let dict = [PROFILEIMAGEURL1: PLACEHOLDERIMAGEURL,
                    PROFILEIMAGEURL2: "",
                    PROFILEIMAGEURL3: ""]
        
        updateUser(withValue: dict)
        hudSetup()
        toEnterProfessionVC()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        picker.delegate = self
        anyLabel.layer.borderWidth = 1
        anyLabel.layer.borderColor = UIColor.systemGray3.cgColor
        descriptionLabel.text = "プロフィール画像を設定してください。\nあとで設定する場合はスキップを押してください。"
        nextButton.layer.cornerRadius = 50 / 2
        nextButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowRadius = 4
        skipButton.layer.cornerRadius = 50 / 2
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        profileImageView.layer.cornerRadius = 150 / 2
    }
    
    private func hudSetup() {
        
        hud.textLabel.text = "保存が成功しました。"
        self.indicator.stopAnimating()
        hud.show(in: self.view)
        hudSuccess()
        self.toEnterProfessionVC()
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
