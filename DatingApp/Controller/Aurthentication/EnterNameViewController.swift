//
//  EnterNameViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterNameViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var requiredLabel: UILabel!
    
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

        if textFieldHaveText() {
            
            if nameTextField.text!.count > 10 {
                generator.notificationOccurred(.error)
                hud.textLabel.text = "10文字以下で入力してください。"
                hud.show(in: self.view)
                hudError()
                return
            }
            nextButton.isEnabled = false
            saveUserName()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "名前を入力してください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    private func saveUserName() {
        
        let dict = [USERNAME: nameLabel.text]
        updateUser(withValue: dict as [String : Any])

        toEnterAgeVC()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
                
        nameTextField.becomeFirstResponder()
        nameLabel.text = "-"
        requiredLabel.layer.borderWidth = 1
        requiredLabel.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        descriptionLabel.text = "名前を10文字以下で入力してください。"
        nextButton.layer.cornerRadius = 50 / 2
        nextButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowRadius = 4
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        nameLabel.text = nameTextField.text
    }
    
    private func textFieldHaveText() -> Bool {
        
        return nameTextField.text != ""
    }
    
    // MARK: - Navigation
    
    private func toEnterAgeVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterAgeVC = storyboard.instantiateViewController(withIdentifier: "EnterAgeVC")
            self.present(toEnterAgeVC, animated: true, completion: nil)
        }
    }

}
