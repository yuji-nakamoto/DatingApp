//
//  ShopTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/25.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    func shopItem1() {
        itemImageView.image = UIImage(named: "item1")
        itemNameLabel.text = "メッセージ送信できる券"
        descriptionLabel.text = "マッチしていなくてもメッセージを1回送れます"
        pointLabel.text = String(1)
    }
    
    func possessionItem1(_ user: User) {
        itemImageView.image = UIImage(named: "item1")
        itemNameLabel.text = "メッセージ送信できる券"
        descriptionLabel.text = "マッチしていなくてもメッセージを1回送れます"
        if user.item1 != nil {
            pointLabel.text = String(user.item1)
        }
    }
}
