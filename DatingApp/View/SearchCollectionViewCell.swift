//
//  SearchCollectionViewCell.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var selfIntroLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var typeCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    // MARK: - Helpers
    
    func configureCell(_ user: User) {
        
        getLikeCount(ref: COLLECTION_LIKECOUNTER.document(user.uid))
        getTypeCount(ref: COLLECTION_TYPECOUNTER.document(user.uid))
        backView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = 150 / 2
        statusView.layer.cornerRadius = 15 / 2
        
        ageLabel.text = String(user.age) + "歳"
        residenceLabel.text = user.residence
        selfIntroLabel.text = user.selfIntro
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        
        COLLECTION_USERS.document(user.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch is online: \(error.localizedDescription)")
            }
            if let dict = snapshot?.data() {
                if let active = dict[STATUS] as? String {
                    self.statusView.backgroundColor = active == "online" ? .systemGreen : .systemOrange
                }
            }
        }
    }
    
    func getLikeCount(ref: DocumentReference) {
        ref.collection(SHARDS).getDocuments() { (querySnapshot, err) in
            var totalLikeCount = 0
            if  let err = err {
                print("Error total count: \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let likeCount = document.data()[LIKECOUNT] as! Int
                    totalLikeCount += likeCount
                }
            }
            self.likeCountLabel.text = String(totalLikeCount)
        }
    }
    
    func getTypeCount(ref: DocumentReference) {
        ref.collection(SHARDS).getDocuments() { (querySnapshot, err) in
            var totalTypeCount = 0
            if  let err = err {
                print("Error total count: \(err.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let typeCount = document.data()[TYPECOUNT] as! Int
                    totalTypeCount += typeCount
                }
            }
            self.typeCountLabel.text = String(totalTypeCount)
        }
    }

}
