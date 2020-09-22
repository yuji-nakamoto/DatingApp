//
//  ChangePasswordViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/14.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase
import TextFieldEffects

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var hud = JGProgressHUD(style: .dark)
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 230, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 290, width: 300, height: 60))
    private let newPasswordTextField = HoshiTextField(frame: CGRect(x: 40, y: 350, width: 300, height: 60))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        doneButton.isEnabled = false

        if textFieldHaveText() {
            indicator.startAnimating()

            withdrawUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            doneButton.isEnabled = true
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Withdraw
    
    private func withdrawUser() {
                
        let email = emailTextField.text
        let password = passwordTextField.text
        let newPassword = newPasswordTextField.text
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("Error reauth: \(error.localizedDescription)")
                self.hud.textLabel.text = "メールアドレス、もしくはパスワードが間違えています"
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 2.0)
                self.indicator.stopAnimating()
                self.doneButton.isEnabled = true
            } else {
                
                AuthService.changePassword(password: newPassword!) { (error) in
                    if let error = error {
                        print("Error change password: \(error.localizedDescription)")
                    } else {
                        self.hud.textLabel.text = "パスワードを変更しました"
                        self.hud.show(in: self.view)
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.dismiss(afterDelay: 2.0)
                        self.doneButton.isEnabled = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.dismiss(animated: true)
                        }
                    }
                    self.indicator.stopAnimating()
                }
            }
        })
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        emailTextField.placeholderColor = UIColor(named: O_GREEN)!
        emailTextField.borderActiveColor = UIColor(named: O_RED)
        emailTextField.borderInactiveColor = UIColor(named: O_GREEN)
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "今までメールアドレス"
        emailTextField.keyboardType = .emailAddress
        self.view.addSubview(emailTextField)
        
        passwordTextField.placeholderColor = UIColor(named: O_GREEN)!
        passwordTextField.borderActiveColor = UIColor(named: O_RED)
        passwordTextField.borderInactiveColor = UIColor(named: O_GREEN)
        passwordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "今までパスワード"
        self.view.addSubview(passwordTextField)
        
        newPasswordTextField.placeholderColor = UIColor(named: O_GREEN)!
        newPasswordTextField.borderActiveColor = UIColor(named: O_RED)
        newPasswordTextField.borderInactiveColor = UIColor(named: O_GREEN)
        newPasswordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.placeholder = "新しいパスワード"
        self.view.addSubview(newPasswordTextField)
        
        descriptionlabel.text = "今までのメールアドレス、\n今までのパスワード、\n新しいパスワードを入力してください。"
        doneButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func textFieldHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "" && newPasswordTextField.text != "")
    }
}
