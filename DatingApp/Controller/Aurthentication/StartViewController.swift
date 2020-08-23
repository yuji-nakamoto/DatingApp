//
//  StartViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StartViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColor()
        autoLogin()
        interstitial = createAndLoadIntersitial()
        UserDefaults.standard.removeObject(forKey: LANKBAR)
    }
    
    // MARK: - Helpers
    
    private func autoLogin() {
        indicator.startAnimating()
        if UserDefaults.standard.object(forKey: RCOMPLETION) != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                    self.toTabBerVC()
                }
            }
            return
        }
        indicator.stopAnimating()
        toSelectLoginVC()
    }

    private func setupColor() {
        if UserDefaults.standard.object(forKey: PINK) != nil {
            logoLabel.textColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            logoLabel.textColor = UIColor(named: O_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            logoLabel.textColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            logoLabel.textColor = UIColor(named: O_DARK)
        }
    }
    
    private func toTabBerVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabBerVC")
        self.present(toTabBerVC, animated: true, completion: nil)
    }
    
    private func toSelectLoginVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
            self.present(toSelectLoginVC, animated: true, completion: nil)
        }
    }
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/4674347886")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
        indicator.stopAnimating()
        toTabBerVC()
    }
}
