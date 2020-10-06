//
//  ItemTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usedLabel2: UILabel!
    @IBOutlet weak var usedLabel3: UILabel!
    @IBOutlet weak var usedLabel4: UILabel!
    @IBOutlet weak var usedLabel5: UILabel!
    @IBOutlet weak var usedLabel6: UILabel!
    @IBOutlet weak var usedLabel7: UILabel!
    @IBOutlet weak var isReadSwitch: UISwitch!
    @IBOutlet weak var isReadLabel: UILabel!
    
    var itemVC: ItemCollectionViewController?
    
    func usedItems(_ user: User) {
        guard user.uid != nil else { return }
        
        if user.usedItem2 > 0 {
            self.usedLabel2.text = "\(user.usedItem2!)枚使用中"
            self.usedLabel2.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel2.text = "未使用"
            self.usedLabel2.textColor = .systemGray
        }
        
        if user.usedItem3 > 0 {
            self.usedLabel3.text = "\(user.usedItem3!)枚使用中"
            self.usedLabel3.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel3.text = "未使用"
            self.usedLabel3.textColor = .systemGray
        }
        
        if user.usedItem5 > 0 {
            self.usedLabel4.text = "\(user.usedItem5!)枚使用中"
            self.usedLabel4.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel4.text = "未使用"
            self.usedLabel4.textColor = .systemGray
        }
        
        if user.usedItem6 > 0 {
            self.usedLabel5.text = "使用中"
            self.usedLabel5.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel5.text = "未使用"
            self.usedLabel5.textColor = .systemGray
        }
        
        if user.usedItem7 > 0 {
            self.usedLabel6.text = "使用中"
            self.usedLabel6.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel6.text = "未使用"
            self.usedLabel6.textColor = .systemGray
        }
        
        if user.usedItem8 > 0 {
            self.usedLabel7.isHidden = true
        } else {
            self.usedLabel7.isHidden = false
            self.usedLabel7.text = "未使用"
            self.usedLabel7.textColor = .systemGray
        }
    }
    
    func setupIsRead(_ user: User) {
        
        if user.usedItem8 == 1 {
            self.isReadSwitch.isHidden = false
            self.isReadLabel.text = "既読表示をする"
            
            if UserDefaults.standard.object(forKey: ISREAD_ON) != nil {
                self.isReadSwitch.isOn = true
                self.isReadLabel.text = "既読表示をする"
            } else {
                self.isReadSwitch.isOn = false
                self.isReadLabel.text = "既読表示をしない"
            }
            
        } else {
            self.isReadSwitch.isHidden = true
            self.isReadLabel.text = "透視"
        }
    }
    
    @IBAction func isReadSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: ISREAD_ON)
            self.isReadLabel.text = "既読表示をする"

        } else {
            UserDefaults.standard.removeObject(forKey: ISREAD_ON)
            self.isReadLabel.text = "既読表示をしない"
        }
    }
}
