//
//  InquiryTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import TextFieldEffects

class InquiryTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var inquiryLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    private var currentUser = User()
    private var hud = JGProgressHUD(style: .dark)
    private let emailTextField = HoshiTextField(frame: CGRect(x: 20, y: 250, width: 400, height: 60))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrentUser()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if inquiryLabel.text == "お問い合わせ内容" {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "内容を入力してください"
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        if emailTextField.text == "" {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "メールアドレスを入力してください"
            hud.dismiss(afterDelay: 2.0)
            return
        }
        saveInquiry()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.setupUserInfo(self.currentUser)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveInquiry() {
        
        let dict = [FROM: currentUser.uid!,
                    GENDER: currentUser.gender as Any,
                    USERNAME: currentUser.username as Any,
                    EMAIL: emailTextField.text!,
                    INQUIRY: inquiryLabel.text!,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_INQUIRY.document(User.currentUserId()).collection("inquirys").document().setData(dict)

        updateUser(withValue: [INQUIRY: ""])
        hud.textLabel.text = "送信が完了しました"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            hud.dismiss()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
        navigationItem.title = "お問い合わせ"
        sendButton.layer.cornerRadius = 15
        emailTextField.delegate = self
        
        emailTextField.placeholderColor = UIColor(named: O_GREEN)!
        emailTextField.borderActiveColor = UIColor(named: O_RED)
        emailTextField.borderInactiveColor = UIColor(named: O_GREEN)
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        self.view.addSubview(emailTextField)
    }
    
    private func setupUserInfo(_ currentUser: User) {
        
        if currentUser.inquiry == "" {
            inquiryLabel.text = "お問い合わせ内容"
            inputLabel.isHidden = false
        } else {
            inquiryLabel.text = currentUser.inquiry
            inputLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
