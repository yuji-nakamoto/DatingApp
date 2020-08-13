//
//  VerifiedViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class VerifiedViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var hud = JGProgressHUD(style: .dark)
    
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
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        
        AuthService.resendVerificaitionEmail(email: emailTextField.text!) { (error) in
            print("Error: \(String(describing: error?.localizedDescription))")
        }
        hud.textLabel.text = "認証のメールを再送信しました。"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
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
            self.toEnterNameVC()
            self.activityIndicator.stopAnimating()
        }
        
//        AuthService.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
//            if error == nil {
//
//                if isEmailVerified {
//                    self.hud.textLabel.text = "メールの認証に成功しました。"
//                    self.hud.show(in: self.view)
//                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//                    self.hud.dismiss(afterDelay: 2.0)
//
//                    let dict = [UID: User.currentUserId(),
//                                EMAIL: self.emailTextField.text!] as [String : Any]
//                    saveUser(userId: User.currentUserId(), withValue: dict)
//
//                    self.toEnterNameVC()
//                } else {
//                    generator.notificationOccurred(.error)
//                    self.loginButton.isEnabled = true
//                    self.hud.textLabel.text = "メールを確認してください。"
//                    self.hud.show(in: self.view)
//                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    self.hud.dismiss(afterDelay: 2.0)
//                }
//            } else {
//                self.loginButton.isEnabled = true
//                self.hud.textLabel.text = error!.localizedDescription
//                self.hud.show(in: self.view)
//                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                self.hud.dismiss(afterDelay: 2.0)
//            }
//            self.activityIndicator.stopAnimating()
//        }
    }
    
    // MARK: - Helpers

    private func setupUI() {
        
        descriptionLabel.text = "メールに記載しているURLを開き、認証を完了させてください。"
        loginButton.layer.cornerRadius = 50 / 2
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
    
    private func toEnterNameVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterNameVC = storyboard.instantiateViewController(withIdentifier: "EnterNameVC")
            self.present(toEnterNameVC, animated: true, completion: nil)
        }
    }
    
}
