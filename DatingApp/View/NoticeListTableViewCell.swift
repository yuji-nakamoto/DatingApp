//
//  NoticeListTableViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NoticeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    func configureCell(_ notice: Notice) {

        titleLabel.text = notice.title
        
        if notice.genre == "重要" {
            genreLabel.textColor = .systemRed
            genreLabel.text = "     重要     "
            genreLabel.layer.borderColor = UIColor.systemRed.cgColor
        } else if notice.genre == "アップデート" {
            genreLabel.textColor = .systemBlue
            genreLabel.text = "     アップデート     "
            genreLabel.layer.borderColor = UIColor.systemBlue.cgColor
        }
        
        let date = notice.time.dateValue()
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        timeLabel.text = dateFormatter.string(from: date)
    }
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        genreLabel.layer.borderWidth = 1
        genreLabel.layer.cornerRadius = 8
    }
}
