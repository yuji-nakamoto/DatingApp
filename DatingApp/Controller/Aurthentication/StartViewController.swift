//
//  StartViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    // MARK: - Lifecycle

    @IBOutlet weak var logoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColor()
        autoLogin()
    }
    
    // MARK: - Helpers
    
    private func autoLogin() {
        
        if UserDefaults.standard.object(forKey: RCOMPLETION) != nil {
            toTabBerVC()
            return
        }
        toSelectLoginVC()
    }
    
    private func setupColor() {
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            logoLabel.textColor = UIColor(named: O_PINK)
        } else {
            logoLabel.textColor = UIColor(named: O_GREEN)
        }
    }
    
    private func toTabBerVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabBerVC")
            self.present(toTabBerVC, animated: true, completion: nil)
        }
    }
    
    private func toSelectLoginVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
            self.present(toSelectLoginVC, animated: true, completion: nil)
        }
    }

}
