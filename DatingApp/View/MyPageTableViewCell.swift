//
//  MyPageTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cogImageView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var typeNewLabel: UILabel!
    @IBOutlet weak var likeNewLabel: UILabel!
    @IBOutlet weak var crown: UIImageView!
    @IBOutlet weak var missionNewLabel: UILabel!
    @IBOutlet weak var missionTopLabel: UILabel!
    
    var myPageVC: MyPageTableViewController?
    
    func configureCell(_ user: User) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTap))
        profileImageView.addGestureRecognizer(tap)
        
        if user.uid != nil {
            profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            nameLabel.text = user.username
            pointLabel.text = String(user.points)
        }
        
        if user.newType == true {
            typeNewLabel.isHidden = false
        } else {
            typeNewLabel.isHidden = true
        }
        
        if user.newLike == true {
            likeNewLabel.isHidden = false
        } else {
            likeNewLabel.isHidden = true
        }
        
        if user.newMission == true {
            missionTopLabel.text = "ミッション報酬が獲得できます！"
            missionNewLabel.isHidden = false
        } else {
            missionTopLabel.text = "ミッションでフリマポイントを獲得しよう！"
            missionNewLabel.isHidden = true
        }
        
        if user.mMissionClear == true {
            missionTopLabel.text = "全ミッションクリアおめでとう！"
            crown.isHidden = false
        } else {
            crown.isHidden = true
        }
        
        if user.comment == "" {
            commentLabel.text = "挨拶や今日の出来事など入力してみよう"
        } else {
            commentLabel.text = user.comment
        }
    }
    
    @objc func profileImageViewTap() {
        myPageVC?.performSegue(withIdentifier: "ProfileVC", sender: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        crown.isHidden = true
        typeNewLabel.layer.cornerRadius = 25 / 2
        likeNewLabel.layer.cornerRadius = 25 / 2
        missionNewLabel.layer.cornerRadius = 25 / 2
        nameLabel.text = ""
        profileButton.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 100 / 2
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 270)
        profileImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toCommentVC))
        commentView.addGestureRecognizer(tap)
    }
    
    @objc func toCommentVC() {
        myPageVC?.performSegue(withIdentifier: "CommentVC", sender: nil)
    }
    
    
    @IBAction func toNoticeListVC(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toNoticeListVC = storyboard.instantiateViewController(withIdentifier: "NoticeListVC") as! MyUINavigationViewController
        myPageVC?.present(toNoticeListVC, animated: true, completion: nil)
    }
    
    func cogAnimation() {
        let rollingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rollingAnimation.fromValue = 0
        rollingAnimation.toValue = CGFloat.pi * 0.2
        rollingAnimation.duration = 0.3
        rollingAnimation.repeatDuration = CFTimeInterval.zero
        cogImageView.layer.add(rollingAnimation, forKey: "rollingImage")
    }
}
