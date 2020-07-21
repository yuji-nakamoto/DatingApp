//
//  RegisterViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let jgHud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
            
            createUser()
        } else {
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
    }
    
    
    // MARK: - Helpers
    
    private func createUser() {
        
        self.activityIndicator.startAnimating()
        User.createUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                hud.textLabel.text = error!.localizedDescription
                hud.show(in: self.view)
                hudError()
                self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            hud.textLabel.text = "認証確認のメールを送りました。\nメールを認証しログインしてください。"
            hud.show(in: self.view)
            hudSuccess()
            UserDefaults.standard.set(true, forKey: "toVerifiedVC")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.view.endEditing(true)
                self.toVerifiedVC()
            }
        }
    }
    
    private func setupUI() {
        
        if UserDefaults.standard.object(forKey: "toVerifiedVC") != nil {
            resendButton.isHidden = false
        } else {
            resendButton.isHidden = true
        }
        
        descriptionLabel.text = "メールアドレスとパスワードを\n入力してください。"
        doneButton.layer.cornerRadius = 50 / 2
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        dismissButton.layer.cornerRadius = 50 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        resendButton.layer.cornerRadius = 50 / 2
        resendButton.layer.borderWidth = 1
        resendButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor

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
    
    private func toVerifiedVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifiedVC = storyboard.instantiateViewController(withIdentifier: "VerifiedVC")
        self.present(verifiedVC, animated: true, completion: nil)
    }
    
    
    
}
