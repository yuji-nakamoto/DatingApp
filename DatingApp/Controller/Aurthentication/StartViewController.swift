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
    @IBOutlet weak var iconLeft: UIImageView!
    @IBOutlet weak var iconRight: UIImageView!
    
    private var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView()
        autoLogin()
        interstitial = createAndLoadIntersitial()
//        interstitial = testIntersitial()
    }
    
    // MARK: - Helpers
    
    private func autoLogin() {
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
        toSelectLoginVC()
    }
    
    private func animationView() {
        
        logoLabel.alpha = 0
        iconLeft.transform = CGAffineTransform(translationX: -200, y: 0)
        iconRight.transform = CGAffineTransform(translationX: 200, y: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               self.iconLeft.transform = .identity
               self.iconRight.transform = .identity
            }, completion: nil)

            UIView.animate(withDuration: 1, delay: 0.7, animations: {
                self.logoLabel.alpha = 1
            })
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
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/4674347886")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func testIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
        toTabBerVC()
    }
}
