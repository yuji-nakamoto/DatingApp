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
    @IBOutlet weak var redmark: UIView!
    @IBOutlet weak var cogImageView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var typeNewLabel: UILabel!
    @IBOutlet weak var likeNewLabel: UILabel!
    
    var myPageVC: MyPageTableViewController?
    
    func configureCell(_ user: User?) {
        
        if user?.uid != nil {
            profileImageView.sd_setImage(with: URL(string: user!.profileImageUrl1), completed: nil)
            nameLabel.text = user!.username
            pointLabel.text = String(user!.points)
        }
        
        if user?.newType == true {
            typeNewLabel.isHidden = false
        } else {
            typeNewLabel.isHidden = true
        }
        
        if user?.newLike == true {
            likeNewLabel.isHidden = false
        } else {
            likeNewLabel.isHidden = true
        }
    }
    
    func configureCommentCell(_ comment: Comment) {
        if comment.text == "" {
            commentLabel.text = "挨拶や今日の出来事など入力してみよう"
        } else {
            commentLabel.text = comment.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        typeNewLabel.layer.cornerRadius = 15 / 2
        likeNewLabel.layer.cornerRadius = 15 / 2
        redmark.layer.cornerRadius = 4
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
