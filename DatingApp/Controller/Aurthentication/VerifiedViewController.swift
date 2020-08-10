//
//  VerifiedViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class VerifiedViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
            
            loginButton.isEnabled = false
            loginUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        
        AuthService.resendVerificaitionEmail(email: emailTextField.text!) { (error) in
            print("Error: \(String(describing: error?.localizedDescription))")
        }
        hud.textLabel.text = "認証メールを再送信しました。"
        hud.show(in: self.view)
        hudSuccess()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - User
    
    private func loginUser() {
        
        self.activityIndicator.startAnimating()
        
        AuthService.testLoginUser(email: emailTextField.text!, password: passwordTextField.text!) {
            let dict = [UID: User.currentUserId(),
                        EMAIL: self.emailTextField.text!] as [String : Any]
            saveUser(userId: User.currentUserId(), withValue: dict)
            self.toEnterGenderVC()
            self.activityIndicator.stopAnimating()
        }
        
//        AuthService.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
//            if error == nil {
//
//                if isEmailVerified {
//                    hud.textLabel.text = "メールの認証に成功しました。"
//                    hud.show(in: self.view)
//                    hudSuccess()
//
//                    let dict = [UID: User.currentUserId(),
//                                EMAIL: self.emailTextField.text!] as [String : Any]
//                    saveUser(userId: User.currentUserId(), withValue: dict)
//
//                    self.toEnterGenderVC()
//                } else {
//                    generator.notificationOccurred(.error)
//                    self.loginButton.isEnabled = true
//                    hud.textLabel.text = "認証メールを確認してください。"
//                    hud.show(in: self.view)
//                    hudError()
//                }
//            } else {
//                self.loginButton.isEnabled = true
//                hud.textLabel.text = error!.localizedDescription
//                hud.show(in: self.view)
//                hudError()
//            }
//            self.activityIndicator.stopAnimating()
//        }
    }
    
    // MARK: - Helpers

    private func setupUI() {
        
        descriptionLabel.text = "認証メールに記載しているURLを開いて、認証を完了させてください。\n\n認証がお済みであればログインを行い、ユーザー情報の入力を進めてください。"
        loginButton.layer.cornerRadius = 50 / 2
        loginButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.3
        loginButton.layer.shadowRadius = 4
        resendButton.layer.cornerRadius = 50 / 2
        resendButton.layer.borderWidth = 1
        resendButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        backButton.layer.cornerRadius = 50 / 2
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
        
        return (emailTextField.text != "" && passwordTextField.text != "")
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
