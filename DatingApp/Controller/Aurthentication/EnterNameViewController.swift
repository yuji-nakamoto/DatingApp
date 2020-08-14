//
//  EnterNameViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class EnterNameViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.prepareSave()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    private func saveUserName() {
        
        let dict = [USERNAME: nameLabel.text]
        updateUser(withValue: dict as [String : Any])
        indicator.stopAnimating()
        
        toEnterProfileImageVC()
    }
    
    // MARK: - Helpers
    
    private func prepareSave() {
        
        if textFieldHaveText() {
            
            if nameTextField.text!.count > 10 {
                generator.notificationOccurred(.error)
                hud.textLabel.text = "10文字以下で入力してください。"
                hud.show(in: self.view)
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2.0)
                indicator.stopAnimating()
                return
            }
            nextButton.isEnabled = false
            saveUserName()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "名前を入力してください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            indicator.stopAnimating()
        }
    }
    
    private func setupUI() {
        
        nameTextField.becomeFirstResponder()
        nameLabel.text = "-"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        descriptionLabel.text = "ニックネームを10文字以下で入力してください。\nニックネームはあとで変更することができます。"
        nextButton.layer.cornerRadius = 50 / 2
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        
        nameLabel.text = nameTextField.text
        
        let nicknameNum = 10 - nameTextField.text!.count
        if nicknameNum < 0 {
            countLabel.text = "文字数制限です"
        } else {
            countLabel.text = String(nicknameNum)
        }
    }
    
    private func textFieldHaveText() -> Bool {
        
        return nameTextField.text != ""
    }
    
    // MARK: - Navigation
    
    private func toEnterProfileImageVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterProfileImageVC = storyboard.instantiateViewController(withIdentifier: "EnterProfileImageVC")
            self.present(toEnterProfileImageVC, animated: true, completion: nil)
        }
    }
    
}
