//
//  PrivacyPolicyTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/16.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class PrivacyPolicyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var privacy1Label: UILabel!
    @IBOutlet weak var privacy2Label: UILabel!
    @IBOutlet weak var privacy2Label1: UILabel!
    @IBOutlet weak var privacy2Label2: UILabel!
    @IBOutlet weak var privacy2Label3: UILabel!
    @IBOutlet weak var privacy2Label4: UILabel!
    @IBOutlet weak var privacy3Label: UILabel!
    @IBOutlet weak var privacy3Label1: UILabel!
    @IBOutlet weak var privacy3Label2: UILabel!
    @IBOutlet weak var privacy3Label3: UILabel!
    @IBOutlet weak var privacy3Label4: UILabel!
    @IBOutlet weak var privacy4Label: UILabel!
    @IBOutlet weak var privacy4Label1: UILabel!
    @IBOutlet weak var privacy4Label2: UILabel!
    @IBOutlet weak var privacy4Label3: UILabel!
    @IBOutlet weak var privacy4Label4: UILabel!
    @IBOutlet weak var privacy5Label: UILabel!
    @IBOutlet weak var privacy6Label: UILabel!
    
    func setupUI() {
        
        privacy1Label.text = "フリマ運営局は、個人情報とは、個人情報の保護に関する法律に規定される生存する個人の情報（氏名、生年月日、その他の特定の個人を識別することができる情報）、ならびに特定の個人と結びついて使用されるメールアドレス、ユーザーID、パスワードなどの情報、および個人情報と一体となった趣味、家族構成、年齢その他の個人に関する属性情報であると認識しています。"
        
        privacy2Label.text = "フリマ運営局は、あらかじめご本人の同意を得ず、利用目的の達成に必要な範囲を超えて個人情報を取り扱うことはありません。ただし、次の場合はこの限りではありません。"
        privacy2Label1.text = "法令に基づく場合"
        privacy2Label2.text = "人の生命、身体または財産の保護のために必要がある場合であって、ご本人の同意を得ることが困難であるとき"
        privacy2Label3.text = "公衆衛生の向上または児童の健全な育成の推進のために特に必要がある場合であって、ご本人の同意を得ることが困難であるとき"
        privacy2Label4.text = "国の機関もしくは地方公共団体またはその委託を受けた者が法令の定める事務を遂行することに対して協力する必要がある場合であって、ご本人の同意を得ることにより当該事務の遂行に支障を及ぼすおそれがあるとき"
        
        privacy3Label.text = "フリマ運営局は、個人情報を取得するにあたり、あらかじめその利用目的を公表します。ただし、次の場合はこの限りではありません。"
        privacy3Label1.text = "利用目的をご本人に通知し、または、公表することによりご本人または第三者の生命、身体、財産その他の権利利益を害するおそれがある場合"
        privacy3Label2.text = "利用目的をご本人に通知し、または公表することによりフリマ運営局の権利または正当な利益を害するおそれがある場合"
        privacy3Label3.text = "国の機関もしくは地方公共団体が法令の定める事務を遂行することに対して協力する必要がある場合であって、利用目的をご本人に通知し、または公表することにより当該事務の遂行に支障を及ぼすおそれがある場合"
        privacy3Label4.text = "取得の状況からみて利用目的が明らかであると認められる場合"
        
        privacy4Label.text = "フリマ運営局は、次に揚げる場合を除くほか、あらかじめご本人の同意を得ないで、個人情報を第三者に提供しません。"
        privacy4Label1.text = "法令に基づく場合"
        privacy4Label2.text = "人の生命、身体または財産の保護のために必要がある場合であって、ご本人の同意を得ることが困難であるとき"
        privacy4Label3.text = "公衆衛生の向上または児童の健全な育成の推進のために特に必要がある場合であって、ご本人の同意を得ることが困難であるとき"
        privacy4Label4.text = "国の機関もしくは地方公共団体またはその委託を受けた者が法令の定める事務を遂行することに対して協力する必要がある場合であって、ご本人の同意を得ることにより当該事務の遂行に支障を及ぼすおそれがあるとき"
        
        privacy5Label.text = "フリマ運営局は、ご本人から、個人情報が真実でないという理由によって、内容の訂正、追加または削除（以下『訂正等』といいます）を求められた場合には、他の法令の規定により特別の手続きが定められている場合を除き、利用目的の達成必要な範囲内において、遅滞なく必要な調査を行い、その結果に基づき、個人情報の内容の訂正等を行い、その旨ご本人に通知します。"
        
        privacy6Label.text = "フリマのプライバシーポリシーに関するお問い合わせは、フリマのお問い合わせフォームまでお願い致します。"
    }
}
