//
//  NewsCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/08.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    
    func configureCell(imageUrl: String, newsItems: NewsItems) {
        
        let frameGradient = CGRect(x: 0, y: 0, width: 414, height: 200)
        contentsImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        
        newsLabel.text = newsItems.title
        NewsItems.fetchThumnImgUrl(urlStr: imageUrl) { [self] (url) in
            contentsImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
