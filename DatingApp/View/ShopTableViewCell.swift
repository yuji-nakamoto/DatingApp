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
        itemNameLabel.text = "おかわり"
        descriptionLabel.text = "マッチしていなくてもメッセージを追加で1通送れます"
        pointLabel.text = "1"
    }
    
    func possessionItem1(_ user: User) {
        itemImageView.image = UIImage(named: "item1")
        itemNameLabel.text = "おかわり"
        descriptionLabel.text = "マッチしていなくてもメッセージを追加で1通送れます"
        if user.item1 != nil {
            pointLabel.text = String(user.item1)
        }
    }
    
    func shopItem2() {
        itemImageView.image = UIImage(named: "item2")
        itemNameLabel.text = "目立ちたがり屋"
        descriptionLabel.text = "あなたのプロフィールが上位に表示されるようになります。効果は重複します"
        pointLabel.text = "1"
    }
    
    func possessionItem2(_ user: User) {
        itemImageView.image = UIImage(named: "item2")
        itemNameLabel.text = "目立ちたがり屋"
        descriptionLabel.text = "あなたのプロフィールが上位に表示されるようになります。効果は重複します"
        if user.item2 != nil {
            pointLabel.text = String(user.item2)
        }
    }
    
    func shopItem3() {
        itemImageView.image = UIImage(named: "item3")
        itemNameLabel.text = "仕切り直し"
        descriptionLabel.text = "スワイプでいなくなったユーザーが復活します"
        pointLabel.text = "3"
    }
    
    func possessionItem3(_ user: User) {
        itemImageView.image = UIImage(named: "item3")
        itemNameLabel.text = "仕切り直し"
        descriptionLabel.text = "スワイプでいなくなったユーザーが復活します"
        if user.item3 != nil {
            pointLabel.text = String(user.item3)
        }
    }
}
