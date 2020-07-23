//
//  DetailCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    func setupProfileImages(profileImage: UIImage) {
        profileImageView.image = profileImage
    }
}
