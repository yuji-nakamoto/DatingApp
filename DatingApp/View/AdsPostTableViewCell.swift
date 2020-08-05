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
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bannerLabel: UILabel!

    var postVC: PostTableViewController?
    
    func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = postVC
        bannerView.load(GADRequest())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 4
        
        bannerView.layer.cornerRadius = 10
        bannerLabel.layer.cornerRadius = 18 / 2
        bannerLabel.backgroundColor = .systemPurple
    }

}
