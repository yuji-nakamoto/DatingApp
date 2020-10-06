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
    
    func shopItem1() {
        itemImageView.image = UIImage(named: "item1")
        itemNameLabel.text = "おかわり"
        descriptionLabel.text = "マッチしていなくてもメッセージを追加で送信できます"
        pointLabel.text = "1"
    }
    
    func shopItem2() {
        itemImageView.image = UIImage(named: "item2")
        itemNameLabel.text = "目立ちたがり屋"
        descriptionLabel.text = "あなたのプロフィールが上位に表示されるようになります。効果は重複します"
        pointLabel.text = "1"
    }

    func shopItem3() {
        itemImageView.image = UIImage(named: "item3")
        itemNameLabel.text = "割り込み"
        descriptionLabel.text = "あなたが送ったメッセージが上位に表示されるようになります。効果は重複します"
        pointLabel.text = "1"
    }

    func shopItem4() {
        itemImageView.image = UIImage(named: "item4")
        itemNameLabel.text = "献上"
        descriptionLabel.text = "気になるお相手にポイントをプレゼントできます。あなたには運営からいいね！をプレゼント！"
        pointLabel.text = "1"
    }

    func shopItem5() {
        itemImageView.image = UIImage(named: "item5")
        itemNameLabel.text = "仕切り直し"
        descriptionLabel.text = "スワイプでいなくなったユーザーが復活します"
        pointLabel.text = "3"
    }
 
    func shopItem6() {
        itemImageView.image = UIImage(named: "item6")
        itemNameLabel.text = "開眼"
        descriptionLabel.text = "あなたのプロフィールに訪れた人数を確認できます。効果は永続します"
        pointLabel.text = "10"
    }

    func shopItem7() {
        itemImageView.image = UIImage(named: "item7")
        itemNameLabel.text = "フリマップ"
        descriptionLabel.text = "お相手との距離表示が可能になります。\n効果は永続します"
        pointLabel.text = "20"
    }

    func shopItem8() {
        itemImageView.image = UIImage(named: "item8")
        itemNameLabel.text = "透視"
        descriptionLabel.text = "メッセージの既読表示が可能になります\n効果は永続します"
        pointLabel.text = "20"
    }
    
    func shopItem9() {
        itemImageView.image = UIImage(named: "item9")
        itemNameLabel.text = "お気に入り"
        descriptionLabel.text = "気になるお相手をお気に入り登録できます"
        pointLabel.text = "2"
    }
}
