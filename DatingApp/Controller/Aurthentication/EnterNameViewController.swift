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
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
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
    
    // MARK: - User
    
    private func fetchUser() {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            User.fetchFemaleUser(User.currentUserId()) { (user) in
                self.user = user
                return
            }
        }
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            User.fetchMaleUser(User.currentUserId()) { (user) in
                self.user = user
            }
        }
    }
    
    private func saveUserName() {
        
        let user = User()
        user.username = nameTextField.text
        user.uid = User.currentUserId()
        user.email = self.user.email
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            updateFemaleUserData1(user)
            toEnterAgeVC()
            return
        }
        updateMaleUserData1(user)
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
