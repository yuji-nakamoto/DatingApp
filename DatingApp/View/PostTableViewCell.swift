//
//  PostTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    private let userDefaults = UserDefaults.standard
    var myPageVC: MyPageTableViewController?
    
    func configureUserCell(_ user: User) {
        
        if user.uid != nil {
            profileImageView.layer.cornerRadius = 10
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            nameLabel.text = user.username
            residenceLabel.text = user.residence
            if user.age != nil {
                ageLabel.text = String(user.age) + "歳"
            }
        }
    }
    
    func configureCurrentUserCell(_ user: User) {
        
        if user.uid != nil {
            profileImageView.layer.cornerRadius = 10
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            nameLabel.text = user.username
            residenceLabel.text = user.residence
            if user.age != nil {
                ageLabel.text = String(user.age) + "歳"
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "削除", message: "投稿を削除しますか？", preferredStyle: .alert)
        let delete: UIAlertAction = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { (alert) in
           
            COLLECTION_POSTS.document(User.currentUserId()).delete { (error) in
                self.myPageVC?.viewWillAppear(true)
            }
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        myPageVC?.present(alert,animated: true,completion: nil)
    }
    
    var post: Post? {
        didSet {
            timeLabel.text = timestamp
            postLabel.text = post?.caption
            genreLabel.layer.cornerRadius = 18 / 2
            genreLabel.textColor = UIColor.white
            genreLabel.text = post?.genre
            
            if genreLabel.text == "恋人募集" {
                genreLabel.text = "   恋人募集   "
                genreLabel.backgroundColor = UIColor.systemPink
                
            } else if genreLabel.text == "友達募集" {
                genreLabel.text = "   友達募集   "
                genreLabel.backgroundColor = UIColor.systemBlue
                
            } else if genreLabel.text == "メル友募集" {
                genreLabel.text = "   メル友募集   "
                genreLabel.backgroundColor = UIColor.systemGreen
                
            } else if genreLabel.text == "遊びたい" {
                genreLabel.text = "   遊びたい   "
                genreLabel.backgroundColor = UIColor.systemOrange
                
            } else {
                genreLabel.text = "   ヒマしてる   "
                genreLabel.backgroundColor = UIColor.systemYellow
            }
        }
    }
    
    var timestamp: String {
        let date = post?.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(EEEEE) H時m分"
        return dateFormatter.string(from: date!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 4
        
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 270)
        profileImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
    }
}
