//
//  EnterNameViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class EnterNameViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var user: User!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUser()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {

        if textFieldHaveText() {
            
            nextButton.isEnabled = false
            saveUserName()
        } else {
            hud.textLabel.text = "名前を入力してください。"
            hud.show(in: self.view)
            hudError()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - User
    
    private func loadUser() {
        
        fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    private func saveUserName() {
        
        let user = User()
        user.username = nameTextField.text
        user.uid = self.user.uid
        user.email = self.user.email
        
        updateUserData1(user)
        toEnterAgeVC()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        UserDefaults.standard.removeObject(forKey: TO_VERIFIED_VC)
        
        nameLabel.text = "-"
        descriptionLabel.text = "名前を入力してください。"
        nextButton.layer.cornerRadius = 50 / 2
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        nameLabel.text = nameTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
