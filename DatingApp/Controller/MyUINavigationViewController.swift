//
//  MyUINavigationViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/01.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MyUINavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupColor()
    }
    
    public func setupColor() {
        
        navigationBar.shadowImage = UIImage()
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil  {
            navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]

        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            navigationBar.barTintColor = UIColor.white
            navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
            
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationBar.barTintColor = UIColor(named: O_DARK)
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}
