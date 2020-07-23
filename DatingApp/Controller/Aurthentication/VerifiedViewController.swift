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
        
        User.resendVerificaitionEmail(email: emailTextField.text!) { (error) in
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
        
        User.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil {
                
                if isEmailVerified {
                    hud.textLabel.text = "メールの認証に成功しました。"
                    hud.show(in: self.view)
                    hudSuccess()
                    let user = User()
                    user.uid = User.currentUserId()
                    user.email = self.emailTextField.text
                    
                    saveMaleUser(user)
                    saveFemaleUser(user)

                    self.toEnterGenderVC()
                } else {
                    generator.notificationOccurred(.error)
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
    
    // MARK: - Helpers

    private func setupUI() {
        
        descriptionLabel.text = "認証メールに記載しているURLを開いて、認証を完了させてください。\n認証がお済みであればメールアドレス、パスワードを入力しログインに進んでください。"
        loginButton.layer.cornerRadius = 50 / 2
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
