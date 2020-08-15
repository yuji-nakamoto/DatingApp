//
//  TermsTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/15.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class TermsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var terms1Label1: UILabel!
    @IBOutlet weak var terms1Label2: UILabel!
    @IBOutlet weak var terms1Label3: UILabel!
    @IBOutlet weak var terms2Label: UILabel!
    @IBOutlet weak var terms3Label1: UILabel!
    @IBOutlet weak var terms3Label2: UILabel!
    @IBOutlet weak var terms3Label3: UILabel!
    @IBOutlet weak var terms4Label1: UILabel!
    @IBOutlet weak var terms4Label1_1: UILabel!
    @IBOutlet weak var terms4Label1_2: UILabel!
    @IBOutlet weak var terms4Label1_3: UILabel!
    @IBOutlet weak var terms4Label2: UILabel!
    @IBOutlet weak var terms5Label1: UILabel!
    @IBOutlet weak var terms5Label2: UILabel!
    @IBOutlet weak var terms5Label3: UILabel!
    @IBOutlet weak var terms5Label4: UILabel!
    @IBOutlet weak var terms5Label5: UILabel!
    @IBOutlet weak var terms5Label6: UILabel!
    @IBOutlet weak var terms5Label7: UILabel!
    @IBOutlet weak var terms5Label8: UILabel!
    @IBOutlet weak var terms5Label9: UILabel!
    @IBOutlet weak var terms5Label10: UILabel!
    @IBOutlet weak var terms5Label11: UILabel!
    @IBOutlet weak var terms5Label12: UILabel!
    @IBOutlet weak var terms5TitleLabel: UILabel!
    
    
    func setupUI() {
        
        titleLabel.text = "本規約は、フリマ運営局（以下、当社）が運営するサービス『フリマ』（以下、本サービス）を通じて、本サービスを利用する利用者様（以下、利用者）に提供するサービスに関して、その諸条件を定めるものです。本サービスを利用されたことにより、本利用規約に同意いただいたものとみなします。"
        terms1Label1.text = "利用者は、本規約の定めに従って本サービスを利用しなければなりません。"
        terms1Label2.text = "利用者は、会員登録をしないかぎり本サービスを利用できません。"
        terms1Label3.text = "利用者は会員登録をするにあたり、本規約に同意していただく事が必要であり、会員登録が完了した時点で、本規約を内容とする本サービス利用規約（以下、本契約）が当社との間で締結されます。"
        
        terms2Label.text = "本サービスは、会員同士が趣味嗜好の合う人を探し、相互にメッセージをやり取りするなどのコミュニケーションを通じて、好みのパートナーと知り合うことができる完全無料のマッチングサービスです。"
        
        terms3Label1.text = "本サービスの利用は、日本在住の１８歳以上（高校生を除く）方に限定しています。"
        terms3Label2.text = "プロフィール情報への登録を目的とした写真等について、被写体が特定できない等、不鮮明な画像データの場合、当社の判断により、掲載ができない場合があります。"
        terms3Label3.text = "当社は、悪質な会員による本利用規約への違反行為を防止する目的等、本サービスの正常かつ健全な運営にために必要な限度で、本サービスへの投稿や、メッセージについて、その内容の一部を確認することがあります。確認の結果、投稿やメッセージの内容が、これらの規約等に違反すると判断した場合は、当社は会員への事前の通知なく、投稿やメッセージの全部または一部を閲覧できないとする、または削除することがあります。"
        
        terms4Label1.text = "当社は、本サービスにおいてプロフィール情報を、以下各号の目的で利用します。"
        terms4Label1_1.text = "本サービスの運営（不正利用の防止や本人確認等を含む）"
        terms4Label1_2.text = "より良いサービス提供のための利用者傾向の分析"
        terms4Label1_3.text = "会員に対して、本サービス運営の変更等に関する連絡"
        terms4Label2.text = "当社は、プロフィール情報のうち、本利用規約に定められる個人情報については、当社の定めるプライバシーポリシーに基づいて取り扱うものとします。"
        terms5TitleLabel.text = "利用者は、本サービスの利用に関して、以下の行為を行ってはならないものとします。利用者がこれらの禁止行為を行ったと当社が判断した場合、利用者に通知することなく、当社は該当する内容のデータの削除、当該利用者に対して注意を促す表示を行う、または利用制限もしくは強制退会させるものとします。"
        terms5Label1.text = "本規約に反する行為"
        terms5Label2.text = "１８歳未満（高校生を含む）の会員登録および本サービスの利用"
        terms5Label3.text = "他の会員、その他第三者について、誹謗中傷もしくは侮辱する、または名誉や信用を傷つける行為、表現、内容の送信等"
        terms5Label4.text = "第三者の財産、プライバシー等個人の権利を侵害する、またはその恐れのある行為、表現、内容の送信等"
        terms5Label5.text = "アダルト画像を含む内容（イラスト等も含む）の送信等"
        terms5Label6.text = "性に関する表現で、わいせつな行為、対象を連想させるもの、その他卑猥な表現・内容の送信等"
        terms5Label7.text = "犯罪その他の法令違反行為を推奨、肯定、もしくは助長させる行為・表現・内容の送信等"
        terms5Label8.text = "相手に恐怖心を生じさせる目的で危害を加えることを通告する脅迫行為やストーカー行為"
        terms5Label9.text = "メールアドレス、LINEID、SNSサービス等の個人情報を収集する行為"
        terms5Label10.text = "売買春を目的として本サービスを利用する行為"
        terms5Label11.text = "無限連鎖講（ねずみ講）、ネットワークビジネス関連の勧誘、及びこれらに類する情報の送信等"
        terms5Label12.text = "その他、当社が不適切と判断する行為"
     

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
