//
//  Extension.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

// MARK: - CAGradientLayer

let gradientLayer = CAGradientLayer()
let leftColor = UIColor(named: O_BLUE)
let rightColor = UIColor(named: O_GREEN)

// MARK: - UINotificationFeedbackGenerator

public let generator = UINotificationFeedbackGenerator()


// MARK : - JGProgressHUD

public var hud = JGProgressHUD(style: .dark)

public func hudError() {
    
    hud.indicatorView = JGProgressHUDErrorIndicatorView()
    hud.dismiss(afterDelay: 2.0)
}

public func hudSuccess() {
    
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.dismiss(afterDelay: 2.0)
}
