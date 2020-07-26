//
//  DetailTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage
import Lottie

class DetailTableViewController: UIViewController {
    
    // MARK: - Propertis
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var superLikeBackView: UIView!
    @IBOutlet weak var likeBackView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var superLikeButton: UIButton!
    
    var profileImages = [UIImage]()
    var user = User()
    var like = Like()
    var superLike = SuperLike()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLikeUser()
        fetchSuperLikeUser()
        downloadImages()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        showLikeAnimation()
        let dict = [UID: user.uid!,
                    USERNAME: user.username!,
                    AGE: user.age!,
                    PROFILEIMAGEURL1: user.profileImageUrl1!,
                    RESIDENCE: user.residence!,
                    ISLIKE: 1] as [String : Any]
        
        Service.saveLikes(forUser: user, isLike: dict)
        likeButton.isEnabled = false
    }
    
    @IBAction func superLikeButtonPressed(_ sender: Any) {

        showSuperLikeAnimation()
        let dict = [UID: user.uid!,
                    USERNAME: user.username!,
                    AGE: user.age!,
                    PROFILEIMAGEURL1: user.profileImageUrl1!,
                    RESIDENCE: user.residence!,
                    ISSUPERLIKE: 1] as [String : Any]
        
        Service.saveSuperLikes(forUser: user, isSuperLike: dict)
        superLikeButton.isEnabled = false
    }
    
    // MARK: - Fetch like
    
    private func fetchLikeUser() {
        
        Like.fetchLikeUser(user.uid) { (like) in
            self.like = like
            
            if like.isLike == 1 {
                self.likeButton.isEnabled = false
            } else {
                self.likeButton.isEnabled = true
            }
        }
    }
    
    private func fetchSuperLikeUser() {
        
        SuperLike.fetchSuperLikeUser(user.uid) { (superLike) in
            self.superLike = superLike
            
            if superLike.isSuperLike == 1 {
                self.superLikeButton.isEnabled = false
            } else {
                self.superLikeButton.isEnabled = true
            }
        }
    }

    
    // MARK: - Download images
    
    private func downloadImages() {
        
        if user.profileImageUrl2 == "" && user.profileImageUrl3 == "" {
            let profileImageUrls = [user.profileImageUrl1] as! [String]
            let imageUrls = profileImageUrls.map({ URL(string: $0) })
            
            for (_, url) in imageUrls.enumerated() {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.profileImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        } else if user.profileImageUrl3 == "" {
            let profileImageUrls = [user.profileImageUrl1, user.profileImageUrl2] as! [String]
            let imageUrls = profileImageUrls.map({ URL(string: $0) })
            
            for (_, url) in imageUrls.enumerated() {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.profileImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        } else {
            let profileImageUrls = [user.profileImageUrl1, user.profileImageUrl2, user.profileImageUrl3] as! [String]
            let imageUrls = profileImageUrls.map({ URL(string: $0) })
            
            for (_, url) in imageUrls.enumerated() {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.profileImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        likeBackView.layer.cornerRadius = 55 / 2
        superLikeBackView.layer.cornerRadius = 55 / 2
        
        likeBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        likeBackView.layer.shadowColor = UIColor.black.cgColor
        likeBackView.layer.shadowOpacity = 0.3
        likeBackView.layer.shadowRadius = 4
        
        superLikeBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        superLikeBackView.layer.shadowColor = UIColor.black.cgColor
        superLikeBackView.layer.shadowOpacity = 0.3
        superLikeBackView.layer.shadowRadius = 4
    }
    
    func showLikeAnimation() {
        let animationView = AnimationView(name: "like")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        view.addSubview(animationView)
        animationView.play()
        
        animationView.play { finished in
            if finished {
                animationView.removeFromSuperview()
            }
        }
    }
    
    func showSuperLikeAnimation() {
        let animationView = AnimationView(name: "superLike")
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        view.addSubview(animationView)
        animationView.play()
        
        animationView.play { finished in
            if finished {
                animationView.removeFromSuperview()
            }
        }
    }
}

//MARK: UICollectionViewDelegate

extension DetailTableViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 375, height: 425)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailCollectionViewCell
        
        cell.setupProfileImages(profileImage: profileImages[indexPath.row])
        return cell
    }
}


// MARK: - UITableViewDelegate
extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
        
        cell.configureCell(user)

        return cell
    }
}
