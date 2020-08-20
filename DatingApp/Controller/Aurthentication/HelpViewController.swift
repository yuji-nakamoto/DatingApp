//
//  HelpViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
    }
}
