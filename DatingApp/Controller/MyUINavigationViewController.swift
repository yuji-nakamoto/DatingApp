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

    public func setupColor() {
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor.white
    }
}
