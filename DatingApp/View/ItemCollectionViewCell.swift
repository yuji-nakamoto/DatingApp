//
//  ItemCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var remainLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var itemCollectionVC: ItemCollectionViewController?
    
    func possessionItem1(_ user: User) {
        itemImageView.image = UIImage(named: "item1")
    
        if user.item1 != nil {
            remainLabel.text = "×" + String(user.item1)
        } else {
            remainLabel.text = "×0"
        }
    }

    func possessionItem2(_ user: User) {
        itemImageView.image = UIImage(named: "item2")
       
        if user.item2 != nil {
            remainLabel.text = String(user.item2)
        } else {
            remainLabel.text = "×0"
        }
    }

    func possessionItem3(_ user: User) {
        itemImageView.image = UIImage(named: "item3")
       
        if user.item3 != nil {
            remainLabel.text = "×" + String(user.item3)
        } else {
            remainLabel.text = "×0"
        }
    }

    func possessionItem4(_ user: User) {
        itemImageView.image = UIImage(named: "item4")
        
        if user.item4 != nil {
            remainLabel.text = "×" + String(user.item4)
        } else {
            remainLabel.text = "×0"
        }
    }
    
    func possessionItem5(_ user: User) {
        itemImageView.image = UIImage(named: "item5")
        
        if user.item5 != nil {
            remainLabel.text = "×" + String(user.item5)
        } else {
            remainLabel.text = "×0"
        }
    }
    
    func possessionItem6(_ user: User) {
        itemImageView.image = UIImage(named: "item6")
        
        if user.item6 != nil {
            remainLabel.text = "×" + String(user.item6)
        } else {
            remainLabel.text = "×0"
        }
    }
    
    func possessionItem7(_ user: User) {
        itemImageView.image = UIImage(named: "item7")
        
        if user.item7 != nil {
            remainLabel.text = "×" + String(user.item7)
        } else {
            remainLabel.text = "×0"
        }
    }
    
    func possessionItem8(_ user: User) {
        itemImageView.image = UIImage(named: "item8")
        
        if user.item8 != nil {
            remainLabel.text = "×" + String(user.item8)
        } else {
            remainLabel.text = "×0"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 5
        remainLabel.text = ""
    }
}
