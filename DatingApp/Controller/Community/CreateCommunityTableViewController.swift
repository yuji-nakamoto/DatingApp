//
//  CreateCommunityTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/18.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class CreateCommunityTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var contentsImage: UIImage?
    private var hud = JGProgressHUD(style: .dark)
    private var user = User()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchCurrentUser()
    }
    
    // MARK: - Actions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        if textField.text == "" {
            hud.textLabel.text = "タイトルを入力してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        if contentsImage == nil {
            hud.textLabel.text = "コミュニティ画像を設定してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        let alert: UIAlertController = UIAlertController(title: textField.text, message: "コミュニティを作成しますか？", preferredStyle: .alert)
        let save: UIAlertAction = UIAlertAction(title: "作成する", style: UIAlertAction.Style.default) { (alert) in
            self.saveContentsImage()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(save)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectPhoto() {
        alertCamera()
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    private func saveContentsImage() {
        
        createButton.isEnabled = false
        indicator.startAnimating()
        contentsImageView.alpha = 0.5
        Service.uploadImage(image: contentsImage!) { (imageUrl) in
            
            let communityId = UUID().uuidString

            if self.user.gender == "男性" {
                
                let dict = [CONTENTSIMAGEURL: imageUrl,
                            COMMUNITYID: communityId,
                            ALL_NUMBER: 1,
                            MALE_NUMBER: 1,
                            COMMUNITYLEADER: self.user.username as Any,
                            CREATED_AT: Timestamp(date: Date()),
                            TITLE: self.textField.text as Any] as [String : Any]
                Community.saveCommunity(communityId: communityId, withValue: dict)
            } else {
                
                let dict = [CONTENTSIMAGEURL: imageUrl,
                            COMMUNITYID: communityId,
                            ALL_NUMBER: 1,
                            FEMALE_NUMBER: 1,
                            COMMUNITYLEADER: self.user.username as Any,
                            CREATED_AT: Timestamp(date: Date()),
                            TITLE: self.textField.text as Any] as [String : Any]
                Community.saveCommunity(communityId: communityId, withValue: dict)
            }
            
            updateUser(withValue: [CREATECOMMUNITYCOUNT: self.user.createCommunityCount + 1])
            
            if self.user.community1 == "" {
                updateUser(withValue: [COMMUNITY1: communityId])
            } else if self.user.community2 == "" {
                updateUser(withValue: [COMMUNITY2: communityId])
            } else if self.user.community3 == "" {
                updateUser(withValue: [COMMUNITY3: communityId])
            } 
            self.hudSetup()
        }
    }
    
    private func hudSetup() {
        
        self.indicator.stopAnimating()
        contentsImageView.alpha = 1
        hud.textLabel.text = "コミュニティを作成しました"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
        }
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
    
    private func setup() {
        
        textField.becomeFirstResponder()
        navigationItem.title = "コミュニティを作成"
        tableView.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        contentsImageView.addGestureRecognizer(tap)
        createButton.layer.cornerRadius = 44 / 2
        contentsImageView.layer.cornerRadius = 15
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreateCommunityTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            
            contentsImageView.image = selectedImage
            contentsImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
