//
//  ImageViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var contentsImageView: UIImageView!
    
    var tweetId = ""
    private var tweet = Tweet()
    private var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTweet()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let move:CGPoint = sender.translation(in:self.view)
        sender.view!.center.y += move.y
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if sender.view!.center.y > 600 || sender.view!.center.y < 100 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let activityItems = ["\(user.username ?? "")さんの投稿をシェア", "\n\(tweet.text ?? "")", contentsImageView.image as Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
    private func fetchTweet() {
        
        Tweet.fetchTweet(tweetId: tweetId) { (tweet) in
            self.tweet = tweet
            self.contentsImageView.sd_setImage(with: URL(string: self.tweet.contentsImageUrl), completed: nil)
            
            User.fetchUser(tweet.uid) { (user) in
                self.user = user
            }
        }
    }
}
