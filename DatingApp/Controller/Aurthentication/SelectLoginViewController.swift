//
//  SelectLoginViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class SelectLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var registertButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Actions
    
    
    @IBAction func mailButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: TO_VERIFIED_VC) != nil {
            toVerifiedVC()
            return
        }
        toLoginVC()
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        
        descriptionLabel.text = "DatingAppは完全無料の\nマッチングアプリです。"
        facebookButton.layer.cornerRadius = 50 / 2
        googleButton.layer.cornerRadius = 50 / 2
        mailButton.layer.cornerRadius = 50 / 2
        mailButton.layer.borderWidth = 1
        mailButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        registertButton.layer.cornerRadius = 50 / 2
        registertButton.layer.borderWidth = 1
        registertButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
    }
    
    // MARK: - Navigation

    private func toVerifiedVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifiedVC = storyboard.instantiateViewController(withIdentifier: "VerifiedVC")
        self.present(verifiedVC, animated: true, completion: nil)
    }
    
    private func toLoginVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toLoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(toLoginVC, animated: true, completion: nil)
    }
    
}
