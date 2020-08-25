//
//  ChangeEmailViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/14.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var hud = JGProgressHUD(style: .dark)
    
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
            changeEmail()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            doneButton.isEnabled = true
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Change email
    
    private func changeEmail() {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let newEmail = newEmailTextField.text
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("Error reauth: \(error.localizedDescription)")
                self.hud.textLabel.text = "メメールアドレス、もしくはパスワードが間違えています。"
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 2.0)
                self.doneButton.isEnabled = true
                self.indicator.stopAnimating()
            } else {
                
                AuthService.changeEmail(email: newEmail!) { (error) in
                    if let error = error {
                        print("Error change email: \(error.localizedDescription)")
                    } else {
                        self.hud.textLabel.text = "メールアドレスを変更しました"
                        self.hud.show(in: self.view)
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.dismiss(afterDelay: 2.0)
                        self.doneButton.isEnabled = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    self.indicator.stopAnimating()
                }
            }
        })
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        descriptionlabel.text = "今までのメールアドレス、\n今までパスワード、\n新しいメールアドレスを入力してください。"
        doneButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            doneButton.backgroundColor = UIColor(named: O_PINK)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            backButton.layer.borderColor = UIColor(named: O_PINK)?.cgColor
            backButton.setTitleColor(UIColor(named: O_PINK), for: .normal)
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            doneButton.backgroundColor = UIColor(named: O_GREEN)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
            backButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            doneButton.backgroundColor = UIColor(named: O_GREEN)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
            backButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            doneButton.backgroundColor = UIColor(named: O_DARK)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            backButton.layer.borderColor = UIColor(named: O_DARK)?.cgColor
            backButton.setTitleColor(UIColor(named: O_DARK), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func textFieldHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "" && newEmailTextField.text != "")
    }
}
