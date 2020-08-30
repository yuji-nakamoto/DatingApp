//
//  AdsPostTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerLabel: UILabel!

    var postVC: PostTableViewController?
    
    func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
        bannerView.rootViewController = postVC
        bannerView.load(GADRequest())
    }
    
    func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = postVC
        bannerView.load(GADRequest())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerLabel.layer.cornerRadius = 18 / 2
        bannerLabel.backgroundColor = .systemPurple
    }
}
