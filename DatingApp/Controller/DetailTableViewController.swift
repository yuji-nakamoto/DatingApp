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
import Firebase

class DetailTableViewController: UIViewController {
    
    // MARK: - Propertis
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageBackView: UIView!
    @IBOutlet weak var typeBackView: UIView!
    @IBOutlet weak var likeBackView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageButton2: UIButton!
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var typeButton2: UIButton!

    var profileImages = [UIImage]()
    var user = User()
    var like = Like()
    var type = Type()
    var userId = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserId()
        fetchLikeUser()
        fetchTypeUser()
        fetchUserIdLike()
        fetchUserIdType()
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
                    ISLIKE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Like.saveIsLikeUser(forUser: user, isLike: dict)
        Like.saveLikedUser(forUser: user)
        incrementLikeCounter(ref: COLLECTION_LIKECOUNTER.document(user.uid), numShards: 10)
        likeButton.isEnabled = false
        likeButton2.isEnabled = false
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        
        showTypeAnimation()
        let dict = [UID: user.uid!,
                    ISTYPE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Type.saveIsTypeUser(forUser: user, isType: dict)
        Type.saveTypedUser(forUser: user)
        incrementTypeCounter(ref: COLLECTION_TYPECOUNTER.document(user.uid), numShards: 10)
        typeButton.isEnabled = false
        typeButton2.isEnabled = false
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        
        toMessageVC()
    }
    
    // MARK: - Fetch like type userId
    
    private func fetchLikeUser() {
        guard user.uid != nil else { return }
        footsteps(user)
        
        Like.fetchLikeUser(user.uid) { (like) in
            self.like = like
            self.validateLikeButton(like: like)
        }
    }
    
    private func fetchTypeUser() {
        guard user.uid != nil else { return }
        footsteps(user)
        
        Type.fetchTypeUser(self.user.uid) { (type) in
            self.type = type
            self.validateTypeButton(type: type)
        }
    }
    
    private func fetchUserId() {
        guard userId != "" else { return }
        footsteps2(userId)
        
        User.fetchUser(userId) { (user) in
            self.user = user
            self.tableView.reloadData()
            self.downloadImages()
        }
    }
    
    private func fetchUserIdType() {
        
        if userId != "" {
            Type.fetchTypeUser(userId) { (type) in
                self.validateTypeButton(type: type)
            }
        }
    }
    
    private func fetchUserIdLike() {
        
        if userId != "" {
            Like.fetchLikeUser(self.userId) { (like) in
                self.validateLikeButton(like: like)
            }
        }
    }
    
    // MARL: - FootStep
    
    private func footsteps(_ user: User) {
        guard user.uid != nil else { return }
        
        let dict = [UID: user.uid!,
                    ISFOOTSTEP: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Footstep.saveIsFootstepUser(forUser: user, isFootStep: dict)
        if UserDefaults.standard.object(forKey: FOOTSTEP_ON) != nil {
            Footstep.saveFootstepedUser(forUser: user)
        }
    }
    
    private func footsteps2(_ userId: String) {
        
        if userId != "" {
            let dict = [UID: userId,
                        ISFOOTSTEP: 1,
                        TIMESTAMP: Timestamp(date: Date())] as [String : Any]
            Footstep.saveIsFootstepUser2(userId: userId, isFootStep: dict)
            if UserDefaults.standard.object(forKey: FOOTSTEP_ON) != nil {
                Footstep.saveFootstepedUser2(userId: userId)
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
        } else if user.profileImageUrl1 != nil && user.profileImageUrl2 != nil && user.profileImageUrl3 != nil {
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
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let userId = sender as! String
            messageVC.userId = userId
        }
    }
    
    // MARK: - Helpers
    
    func incrementLikeCounter(ref: DocumentReference, numShards: Int) {
        
        let shardId = Int(arc4random_uniform(UInt32(numShards)))
        let shardRef = ref.collection(SHARDS).document(String(shardId))
        
        shardRef.updateData([
            LIKECOUNT: FieldValue.increment(Int64(1))
        ])
    }
    
    func incrementTypeCounter(ref: DocumentReference, numShards: Int) {
        
        let shardId = Int(arc4random_uniform(UInt32(numShards)))
        let shardRef = ref.collection(SHARDS).document(String(shardId))
        
        shardRef.updateData([
            TYPECOUNT: FieldValue.increment(Int64(1))
        ])
    }
    
    private func toMessageVC() {
        
        let alert: UIAlertController = UIAlertController(title: "\(user.username!)さんに", message: "メッセージを送りますか？", preferredStyle: .actionSheet)
        let logout: UIAlertAction = UIAlertAction(title: "送る", style: UIAlertAction.Style.default) { (alert) in
            
            self.performSegue(withIdentifier: "MessageVC", sender: self.user.uid)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func configureUI() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        likeBackView.layer.cornerRadius = 55 / 2
        typeBackView.layer.cornerRadius = 55 / 2
        messageBackView.layer.cornerRadius = 55 / 2
        
        likeBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        likeBackView.layer.shadowColor = UIColor.black.cgColor
        likeBackView.layer.shadowOpacity = 0.3
        likeBackView.layer.shadowRadius = 4
        
        typeBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        typeBackView.layer.shadowColor = UIColor.black.cgColor
        typeBackView.layer.shadowOpacity = 0.3
        typeBackView.layer.shadowRadius = 4
        
        messageBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        messageBackView.layer.shadowColor = UIColor.black.cgColor
        messageBackView.layer.shadowOpacity = 0.3
        messageBackView.layer.shadowRadius = 4
    }
    
    private func validateLikeButton(like: Like) {
        
        if like.isLike == 1 {
            likeButton.isEnabled = false
            likeButton2.isEnabled = false
        } else {
            likeButton.isEnabled = true
            likeButton2.isEnabled = true
        }
    }
    
    private func validateTypeButton(type: Type) {
        
        if type.isType == 1 {
            typeButton.isEnabled = false
            typeButton2.isEnabled = false
        } else {
            typeButton.isEnabled = true
            typeButton2.isEnabled = true
        }
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
    
    func showTypeAnimation() {
        
        let animationView = AnimationView(name: "type")
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
        return CGSize(width: 414, height: 414)
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
        
        cell.configureCell(self.user)
        return cell
    }
}
