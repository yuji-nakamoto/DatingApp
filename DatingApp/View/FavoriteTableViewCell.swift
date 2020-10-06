//
//  FavoriteTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var housemateLabel: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var marriageLabel: UILabel!
    @IBOutlet weak var onlineView: UIView!
    
    var user = User()
    var favoriteVC = FavoriteTableViewController()
    
    func configureCell(_ user: User) {
        
        nameLabel.text = user.username
        ageLabel.text = String(user.age) + "歳"
        residenceLabel.text = user.residence
        selfIntroLabel.text = user.selfIntro
        bloodLabel.text = user.blood
        professionLabel.text = user.profession
        housemateLabel.text = user.houseMate
        holidayLabel.text = user.holiday
        marriageLabel.text = user.marriage
        profileImageVIew.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        
        if user.height >= 130 {
            heightLabel.text = String(user.height) + "cm"
        } else {
            heightLabel.text = "未設定"
        }

        
        COLLECTION_USERS.document(user.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.onlineView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
     }
    
    @IBAction func favoButtonPressd(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: user.username + "さん", message: "お気に入り登録を解除しますか？\n※再登録にはアイテムが必要になります", preferredStyle: .actionSheet)
        let release: UIAlertAction = UIAlertAction(title: "解除する", style: UIAlertAction.Style.default) { [self] (alert) in
            Favorite.deleteFavorite(userId: self.user.uid)
            UserDefaults.standard.set(true, forKey: REFRESH2)
            favoriteVC.viewWillAppear(true)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(release)
        alert.addAction(cancel)
        favoriteVC.present(alert, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.layer.cornerRadius = 28 / 2
        profileImageVIew.layer.cornerRadius = 60 / 2
        onlineView.layer.cornerRadius = 15 / 2
        onlineView.layer.borderWidth = 2
        onlineView.layer.borderColor = UIColor.white.cgColor
    }
}
