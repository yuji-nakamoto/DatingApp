//
//  LoginViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
            
            loginUser()
        } else {
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    // MARK: - Helpers
    
    private func loginUser() {
        
        self.activityIndicator.startAnimating()
        
        User.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil {
                
                if isEmailVerified {
                    hud.textLabel.text = "メールの認証に成功しました。"
                    hud.show(in: self.view)
                    hudSuccess()
                } else {
                    hud.textLabel.text = "認証メールを確認してください。"
                    hud.show(in: self.view)
                    hudError()
                }
            } else {
                hud.textLabel.text = error!.localizedDescription
                hud.show(in: self.view)
                hudError()
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func setupUI() {
        
        descriptionlabel.text = "メールアドレスとパスワードを\n入力してください。"
        loginButton.layer.cornerRadius = 50 / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        dismissButton.layer.cornerRadius = 50 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        
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
    
}
