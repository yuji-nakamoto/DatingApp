//
//  EnterProfileImageViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

@available(iOS 13.0, *)
class EnterProfileImageViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var anyLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    private let picker = UIImagePickerController()
    private var profileImage: UIImage?
    private var hud = JGProgressHUD(style: .dark)
    
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
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
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
        alertCamera()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save
    
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
        indicator.stopAnimating()
        toEnterGenderVC()
    }
    
    // MARK: - Helpers
    
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
    
    private func setupUI() {
        
        picker.delegate = self
        anyLabel.layer.borderWidth = 1
        anyLabel.layer.borderColor = UIColor.systemGray3.cgColor
        descriptionLabel.text = "プロフィール画像を設定してください。\nあとで設定する場合はスキップを押してください。"
        nextButton.layer.cornerRadius = 44 / 2
        skipButton.layer.cornerRadius = 44 / 2
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        profileImageView.layer.cornerRadius = 150 / 2
    }
    
    private func hudSetup() {
        
        hud.textLabel.text = "保存が成功しました。"
        self.indicator.stopAnimating()
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
        self.toEnterGenderVC()
    }
    
    // MARK: - Navigation

    private func toEnterGenderVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterGenderVC = storyboard.instantiateViewController(withIdentifier: "EnterGenderVC")
            self.present(toEnterGenderVC, animated: true, completion: nil)
        }
    }
}

@available(iOS 13.0, *)
extension EnterProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            profileImageView.image = selectedImage
            profileImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
