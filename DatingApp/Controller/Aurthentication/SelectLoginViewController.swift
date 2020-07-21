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
    @IBOutlet weak var mailAdressButton: UIButton!
    @IBOutlet weak var registertButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
//        UserDefaults.standard.removeObject(forKey: "toVerifiedVC")
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        
        descriptionLabel.text = "DatingAppは完全無料の\nマッチングアプリです。"
        facebookButton.layer.cornerRadius = 50 / 2
        googleButton.layer.cornerRadius = 50 / 2
        mailAdressButton.layer.cornerRadius = 50 / 2
        mailAdressButton.layer.borderWidth = 1
        mailAdressButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
        registertButton.layer.cornerRadius = 50 / 2
        registertButton.layer.borderWidth = 1
        registertButton.layer.borderColor = UIColor(named: "original_blue")?.cgColor
    }
    
}
