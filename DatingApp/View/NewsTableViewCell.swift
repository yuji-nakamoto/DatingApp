//
//  NewsTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!

    func configureCell(imageUrl: String, newsItems: NewsItems) {
        
        newsLabel.text = newsItems.title
        NewsItems.fetchThumnImgUrl(urlStr: imageUrl) { [self] (url) in
            if url == URL(string: "") {
                contentsImageView.image = UIImage(named: "Placeholder-image")
            } else {
                contentsImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
}
