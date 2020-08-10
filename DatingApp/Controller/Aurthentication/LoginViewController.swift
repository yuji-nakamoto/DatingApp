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
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func segmentedTaped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: UserDefaults.standard.removeObject(forKey: FEMALE); UserDefaults.standard.synchronize()
        case 1: UserDefaults.standard.set(true, forKey: FEMALE); UserDefaults.standard.synchronize()
        default: break
        }
    }
    
    // MARK: - User
    
    private func loginUser() {
        
        self.activityIndicator.startAnimating()
        
        AuthService.testLoginUser(email: emailTextField.text!, password: passwordTextField.text!) {
                   
                   self.toTabBerVC()
                   self.activityIndicator.stopAnimating()
               }
        
//        AuthService.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
//            if error == nil {
//
//                if isEmailVerified {
//                    hud.textLabel.text = "ログインに成功しました。"
//                    hud.show(in: self.view)
//                    hudSuccess()
//                    self.toTabBerVC()
//                } else {
//                    generator.notificationOccurred(.error)
//                    hud.textLabel.text = "認証メールを確認してください。"
//                    hud.show(in: self.view)
//                    hudError()
//                }
//            } else {
//                hud.textLabel.text = error!.localizedDescription
//                hud.show(in: self.view)
//                hudError()
//            }
//            self.activityIndicator.stopAnimating()
//        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        descriptionlabel.text = "メールアドレスとパスワードを\n入力してください。"
        loginButton.layer.cornerRadius = 50 / 2
        loginButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.3
        loginButton.layer.shadowRadius = 4

        dismissButton.layer.cornerRadius = 50 / 2
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
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
    
    private func toTabBerVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UserDefaults.standard.set(true, forKey: RCOMPLETION)
            UserDefaults.standard.synchronize()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabBerVC")
            self.present(toTabBerVC, animated: true, completion: nil)
        }
    }
    
}
