//
//  MyCommunityTableViewCell.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/04.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class MyCommunityTableViewCell: UITableViewCell {

    @IBOutlet weak var communityImageView: UIImageView!
    @IBOutlet weak var communityPostButton: UIButton!
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var communityTitleLbl: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    
    var myCommunityVC: MyCommunityViewController?
    var community = Community()
    var user = User()
    
    func configureCell(_ community: Community) {
        
        communityTitleLbl.text = community.title
        numberLabel.text = String(community.allNumber) + "人" + "(女性: \(String(community.femaleNumber))人, 男性: \(String(community.maleNumber))人)"
        communityImageView.sd_setImage(with: URL(string: community.contentsImageUrl), completed: nil)
        tweetCountLabel.text = String(community.tweetCount) + "投稿"
    }
    
    @objc func tapCommunityImageView() {
        if let uid = community.communityId {
            myCommunityVC?.performSegue(withIdentifier: "CommunityUsersVC", sender: uid)
        }
    }

    @IBAction func communityPostButtonPressd(_ sender: Any) {
        if let uid = community.communityId {
            myCommunityVC?.performSegue(withIdentifier: "TweetVC", sender: uid)
        }
    }
    
    @IBAction func communityButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: community.title, message: "コミュニティを退会しますか？", preferredStyle: .actionSheet)
        let withdraw: UIAlertAction = UIAlertAction(title: "退会する", style: UIAlertAction.Style.default) { (alert) in
            self.setupWithdraw()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(withdraw)
        alert.addAction(cancel)
        myCommunityVC?.present(alert, animated: true, completion: nil)
    }
    
    private func setupWithdraw() {
        
        if user.gender == "男性" {
            Community.updateCommunity1(communityId: self.community.communityId,
                                      value1: [ALL_NUMBER: self.community.allNumber - 1,
                                               MALE_NUMBER: self.community.maleNumber - 1],
                                      value2: [User.currentUserId(): FieldValue.delete()])
        } else {
            Community.updateCommunity1(communityId: self.community.communityId,
                                      value1: [ALL_NUMBER: self.community.allNumber - 1,
                                               FEMALE_NUMBER: self.community.femaleNumber - 1],
                                      value2: [User.currentUserId(): FieldValue.delete()])
        }
        
        if user.community1 == self.community.communityId {
            updateUser(withValue: [COMMUNITY1: ""])
        } else if user.community2 == self.community.communityId {
            updateUser(withValue: [COMMUNITY2: ""])
        } else if user.community3 == self.community.communityId {
            updateUser(withValue: [COMMUNITY3: ""])
        }
        UserDefaults.standard.set(true, forKey: REFRESH2)
        myCommunityVC?.viewWillAppear(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCommunityImageView))
        communityImageView.addGestureRecognizer(tap)
        communityImageView.layer.cornerRadius = 70 / 2
        communityPostButton.layer.cornerRadius = 10
        communityButton.layer.cornerRadius = 10
    }
}
