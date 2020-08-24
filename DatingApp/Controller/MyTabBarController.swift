//
//  MyTabBarController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupColor()
    }

    // MARK: - Helpers
    
    public func setupColor() {
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            tabBar.tintColor = UIColor.white
            tabBar.barTintColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil  {
            tabBar.tintColor = UIColor.white
            tabBar.barTintColor = UIColor(named: O_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            tabBar.tintColor = UIColor(named: O_GREEN)
            tabBar.barTintColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            tabBar.tintColor = UIColor.white
            tabBar.barTintColor = UIColor(named: O_DARK)
        }
    }
}
