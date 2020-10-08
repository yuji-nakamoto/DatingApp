//
//  StartViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import NVActivityIndicatorView

class StartViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    private var interstitial: GADInterstitial!
    lazy var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 + 100, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        //  interstitial = createAndLoadIntersitial()
        interstitial = testIntersitial()
    }
    
    // MARK: - Helpers
    
    private func showLoadingIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    
    private func autoLogin() {
        
        showLoadingIndicator()
        if UserDefaults.standard.object(forKey: RCOMPLETION) != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                    self.hideLoadingIndicator()
                    self.toTabBerVC()
                }
            }
            return
        }
        toSelectLoginVC()
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
            self.hideLoadingIndicator()
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
        hideLoadingIndicator()
        toTabBerVC()
    }
}
