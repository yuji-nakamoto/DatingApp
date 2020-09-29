//
//  FeedTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/17.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var feedVC: FeedTableViewController?
    var user = User()
    var comment: Comment? {
        didSet {
            commentLabel.text = comment?.text
            let date = Date(timeIntervalSince1970: comment!.date)
            let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
            timeLabel.text = dateString
        }
    }
    
    func configureUserCell(_ user: User) {
        
        nameLabel.text = user.username
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {

        if let uid = user.uid {
            feedVC?.performSegue(withIdentifier: "MessageVC", sender: uid)
        }
    }
    
    @objc func toDetailVC() {
        
        if let uid = user.uid {
            feedVC?.performSegue(withIdentifier: "DetailVC", sender: uid)
        }
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toDetailVC))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.layer.cornerRadius = 70 / 2
        backView.layer.cornerRadius  = 15
        backView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowRadius = 4
    }
}
