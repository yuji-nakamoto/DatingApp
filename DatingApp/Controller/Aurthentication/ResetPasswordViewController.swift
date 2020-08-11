//
//  ResetPasswordViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Actions

    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
            
            sendButton.isEnabled = false
            resetPassword()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "メールアドレスを入力してください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func resetPassword() {
        
        AuthService.resetPassword(email: emailTextField.text!) { (error) in
            
            if error != nil {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 2.0)
                return
            }
            self.hud.textLabel.text = "リセットメールを送信しました"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func setupUI() {
        
        descriptionLabel.text = "メールに記載しているURLを開いて、新しいパスワードを登録してください。"
        sendButton.isEnabled = true
        sendButton.layer.cornerRadius = 50 / 2
        sendButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOpacity = 0.3
        sendButton.layer.shadowRadius = 4
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        emailTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func textFieldHaveText() -> Bool {
        
        return emailTextField.text != ""
    }
}
