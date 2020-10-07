//
//  RegisterViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD
import TextFieldEffects

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 225, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 285, width: 300, height: 60))
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        doneButton.isEnabled = true
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        hud.textLabel.text = ""
        hud.show(in: self.view)
        if textFieldHaveText() {
            createUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください"
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    // MARK: - User
    
    private func createUser() {
        
        AuthService.createUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = "既に登録されているアドレスか、アドレスが無効です"
                self.hud.dismiss(afterDelay: 2.0)
                return
            }
            self.hud.textLabel.text = "認証のメールを送りました。\nメールを確認しログインしてください"
            self.hud.dismiss(afterDelay: 3.0)
            UserDefaults.standard.set(true, forKey: TO_VERIFIED_VC)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.view.endEditing(true)
                self.toVerifiedVC()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        emailTextField.placeholderColor = UIColor(named: O_GREEN)!
        emailTextField.borderActiveColor = UIColor(named: O_RED)
        emailTextField.borderInactiveColor = UIColor(named: O_GREEN)
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        self.view.addSubview(emailTextField)
        
        passwordTextField.placeholderColor = UIColor(named: O_GREEN)!
        passwordTextField.borderActiveColor = UIColor(named: O_RED)
        passwordTextField.borderInactiveColor = UIColor(named: O_GREEN)
        passwordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "パスワード"
        self.view.addSubview(passwordTextField)
        
        descriptionLabel.text = "メールアドレスとパスワードを入力して、アカウントを作成してください。"
        doneButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.cornerRadius = 44 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        termsButton.layer.cornerRadius = 44 / 2
        termsButton.layer.borderWidth = 1
        termsButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
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
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    // MARK: - Navigation
    
    private func toVerifiedVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifiedVC = storyboard.instantiateViewController(withIdentifier: "VerifiedVC")
        self.present(verifiedVC, animated: true, completion: nil)
    }
}
