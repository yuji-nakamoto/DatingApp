//
//  NoticeTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/25.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!

    
    func notice1() {
        titleLabel.text = "重要なお知らせ"
        titleLabel2.text = "通信障害による繋がりにくくなっている不具合について"
        mainTextLabel.text = "いつもフリマをご利用いただきまして誠にありがとうございます。\n\n以下の機能を新たに実装しました。\n・ログインボーナス機能\n・ショッピング機能\n・アイテム機能\n・いいねランキング機能"
    }
    
    func notice2() {
        titleLabel.text = "アップデートのお知らせ"
        titleLabel2.text = "新機能を実装しました"
        mainTextLabel.text = "いつもフリマをご利用いただきまして誠にありがとうございます。\n\n以下の機能を新たに実装しました。\n・ログインボーナス機能\n・ショッピング機能\n・アイテム機能\n・いいねランキング機能"
    }
    
    func notice3() {
        titleLabel.text = "アップデートのお知らせ"
        titleLabel2.text = "新機能を実装しました"
        mainTextLabel.text = "いつもフリマをご利用いただきまして誠にありがとうございます。\n\n通信障害により、サービス全体が繋がりにくくなっている事象を確認しました。"
    }
    
    func notice4() {
        titleLabel.text = "通信障害のお知らせ"
        titleLabel2.text = "通信障害による繋がりにくくなっている不具合について"
        mainTextLabel.text = "いつもフリマをご利用いただきまして誠にありがとうございます。\n\n通信障害により、サービス全体が繋がりにくくなっている事象を確認しました。"
    }
    
    func notice5() {
        titleLabel.text = "アップデートのお知らせ"
        titleLabel2.text = "新機能を実装しました"
        mainTextLabel.text = "いつもフリマをご利用いただきまして誠にありがとうございます。\n\n以下の機能を新たに実装しました。\n・ログインボーナス機能\n・ショッピング機能"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
