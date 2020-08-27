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
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var soldoutLabel: UILabel!
    
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
    
    func shopItem4(_ user: User) {
        itemImageView.image = UIImage(named: "item4")
        itemNameLabel.text = "開眼"
        descriptionLabel.text = "あなたのプロフィールに訪れた人数を確認できます。効果は永続します"
        if user.item4 == 1 || user.usedItem4 == 1 {
            pLabel.isHidden = true
            pointLabel.isHidden = true
            soldoutLabel.isHidden = false

        } else {
            pointLabel.text = "10"
        }
    }
    
    func possessionItem4(_ user: User) {
        itemImageView.image = UIImage(named: "item4")
        itemNameLabel.text = "開眼"
        descriptionLabel.text = "あなたのプロフィールに訪れた人数を確認できます。効果は永続します"
        if user.item4 != nil {
            pointLabel.text = String(user.item4)
        }
    }
    
    func shopItem5(_ user: User) {
        itemImageView.image = UIImage(named: "item5")
        itemNameLabel.text = "割り込み"
        descriptionLabel.text = "あなたが送ったメッセージが上位に表示されるようになります。効果は重複します"
        pointLabel.text = "1"
    }
    
    func possessionItem5(_ user: User) {
        itemImageView.image = UIImage(named: "item5")
        itemNameLabel.text = "割り込み"
        descriptionLabel.text = "あなたが送ったメッセージが上位に表示されるようになります。効果は重複します"
        if user.item5 != nil {
            pointLabel.text = String(user.item5)
        }
    }
    
    func shopItem6(_ user: User) {
        itemImageView.image = UIImage(named: "item6")
        itemNameLabel.text = "献上"
        descriptionLabel.text = "気になるお相手にポイントをプレゼントできます"
        pointLabel.text = "1"
    }
    
    func possessionItem6(_ user: User) {
        itemImageView.image = UIImage(named: "item6")
        itemNameLabel.text = "献上"
        descriptionLabel.text = "気になるお相手にポイントをプレゼントできます"
        if user.item6 != nil {
            pointLabel.text = String(user.item6)
        }
    }
}
