//
//  AdsSearchCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsSearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var searchVC: SearchViewController?
    
    // MARK: - Helpers
    
    func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = searchVC
        bannerView.load(GADRequest())
    }
}
