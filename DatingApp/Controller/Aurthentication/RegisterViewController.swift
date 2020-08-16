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
        
        if textFieldHaveText() {
            
            createUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    // MARK: - User
    
    private func createUser() {
        
        self.activityIndicator.startAnimating()
        AuthService.createUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 2.0)
                self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            self.hud.textLabel.text = "認証のメールを送りました。\nメールを確認しログインしてください。"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
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
        
        if UserDefaults.standard.object(forKey: TO_VERIFIED_VC) != nil {
            resendButton.isHidden = false
        } else {
            resendButton.isHidden = true
        }
        
        descriptionLabel.text = "メールアドレスとパスワードを入力して、\nアカウントを作成してください。"
        doneButton.layer.cornerRadius = 50 / 2
        dismissButton.layer.cornerRadius = 50 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        resendButton.layer.cornerRadius = 50 / 2
        resendButton.layer.borderWidth = 1
        resendButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor

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
