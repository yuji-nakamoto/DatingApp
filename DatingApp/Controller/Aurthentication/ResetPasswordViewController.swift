//
//  ResetPasswordViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
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
            hud.textLabel.text = "メールアドレスを入力してください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func resetPassword() {
        
        User.resetPassword(email: emailTextField.text!) { (error) in
            
            if error != nil {
                hud.textLabel.text = error!.localizedDescription
                hud.show(in: self.view)
                hudError()
                return
            }
            hud.textLabel.text = "リセットメールを送信しました"
            hud.show(in: self.view)
            hudSuccess()
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
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        
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
