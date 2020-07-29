//
//  TabBarController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
    }
    
    private func setupColor() {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            UITabBar.appearance().barTintColor = UIColor(named: O_PINK)
        } else {
            UITabBar.appearance().barTintColor = UIColor(named: O_GREEN)
        }
    }

}
