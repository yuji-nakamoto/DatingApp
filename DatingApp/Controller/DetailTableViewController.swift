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
import GoogleMobileAds

class DetailTableViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    
    // MARK: - Propertis
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBackView: UIView!
    @IBOutlet weak var typeBackView: UIView!
    @IBOutlet weak var likeBackView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageButton2: UIButton!
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var typeButton2: UIButton!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var currentUserView: UIImageView!
    @IBOutlet weak var matchedUserView: UIImageView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var afterMessageButton: UIButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    
    private var profileImages = [UIImage]()
    var user = User()
    private var like = Like()
    private var type = Type()
    var userId = ""
    private var badgeUser: User!
    private var currentUser = User()
    private var interstitial: GADInterstitial!
    private var typeUser = Type()
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    lazy var views = [matchLabel, currentUserView, matchedUserView, sendMessageButton, afterMessageButton, congratsLabel, descriptionLabel, descriptionLabel2]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        fetchUserId()
        fetchLikeUser()
        fetchTypeUser()
        fetchUserIdLike()
        fetchUserIdType()
        checkIfMatch()
        configureUI()
        interstitial = createAndLoadIntersitial()
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        showLikeAnimation()
        let dict = [UID: user.uid!,
                    ISLIKE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Like.saveIsLikeUser(forUser: user, isLike: dict)
        Like.saveLikedUser(forUser: user)
        incrementLikeCounter(ref: COLLECTION_LIKECOUNTER.document(user.uid), numShards: 10)
        incrementAppBadgeCount()
        likeButton.isEnabled = false
        likeButton2.isEnabled = false
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        
        let dict = [UID: user.uid!,
                    ISTYPE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Type.saveIsTypeUser(forUser: user, isType: dict)
        Type.saveTypedUser(forUser: user)
        incrementTypeCounter(ref: COLLECTION_TYPECOUNTER.document(user.uid), numShards: 10)
        incrementAppBadgeCount2()
        
        typeButton.isEnabled = false
        typeButton2.isEnabled = false
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
            }
        } else {
            showTypeAnimation()
        }
        if self.typeUser.isType == 1 {
            self.matchView()
            Match.saveMatchUser(forUser: self.user)
        }
    }
    
    @objc func handleDismissal() {
        removeEffectView()
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        toMessageVC()
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        removeEffectView()
        self.performSegue(withIdentifier: "MessageVC", sender: self.user.uid)
    }
    
    @IBAction func afterMessageButtonPressed(_ sender: Any) {
        removeEffectView()
    }
    
    // MARK: - Fetch
    
    private func fetchUserId() {
        guard userId != "" else { return }
        footsteps2(userId)
        
        Type.checkIfMatch(toUserId: userId) { (type) in
            self.typeUser = type
        }
        User.fetchUser(userId) { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchCurrentUser() {
        guard Auth.auth().currentUser?.uid != nil else { return }
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.currentUserView.sd_setImage(with: URL(string: self.currentUser.profileImageUrl1), completed: nil)
        }
    }
    
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
    
    private func checkIfMatch() {
        guard user.uid != nil else { return }
        Type.checkIfMatch(toUserId: user.uid) { (type) in
            self.typeUser = type
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
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let userId = sender as! String
            messageVC.userId = userId
        }
    }
    
    // MARK: - Helpers
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
    }
    
    private func incrementAppBadgeCount() {
        sendRequestNotification2(toUser: self.user, message: "\(self.currentUser.username!)さんがいいねしてくれました", badge: self.user.appBadgeCount + 1)
    }
    
    private func incrementAppBadgeCount2() {
        
        if self.typeUser.isType == 1 {
            sendRequestNotification2(isMatch: 1, toUser: self.user, message: "\(self.currentUser.username!)さんとマッチングしました", badge: self.user.appBadgeCount + 1)
        } else {
            sendRequestNotification2(isMatch: 0, toUser: self.user, message: "誰かがタイプと言っています", badge: self.user.appBadgeCount + 1)
        }
    }
    
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
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.views.forEach({ $0?.alpha = 0 })
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    private func matchView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            self.visualEffectView.frame = self.view.frame
            self.view.addSubview(self.visualEffectView)
            self.visualEffectView.alpha = 0
            self.views.forEach { (view) in
                self.view.addSubview(view!)
            }
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.visualEffectView.alpha = 1
                self.views.forEach({ $0?.alpha = 1})
                self.configureAnimations()
                self.sendMessageButton.isEnabled = true
                self.afterMessageButton.isEnabled = true
                self.matchLabel.text = "\(self.user.username!)さんとマッチしました！"
                self.matchedUserView.sd_setImage(with: URL(string: self.user.profileImageUrl1), completed: nil)
            }, completion: nil)
        }
    }
    
    func configureAnimations() {
                
        let angle = 30 * CGFloat.pi / 180
        
        currentUserView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        matchedUserView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.afterMessageButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserView.transform = .identity
                self.matchedUserView.transform = .identity
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.afterMessageButton.transform = .identity
        }, completion: nil)
    }
    
    private func toMessageVC() {
        
        let alert: UIAlertController = UIAlertController(title: "\(user.username!)さんに", message: "メッセージを送りますか？", preferredStyle: .actionSheet)
        let logout: UIAlertAction = UIAlertAction(title: "送る", style: UIAlertAction.Style.default) { (alert) in
            
            if UserDefaults.standard.object(forKey: FEMALE) == nil {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                }
            }
            self.performSegue(withIdentifier: "MessageVC", sender: self.user.uid)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func configureUI() {
        
        if UserDefaults.standard.object(forKey: CARDVC) != nil {
            buttonStackView.isHidden = true
        } else {
            buttonStackView.isHidden = false
        }
        
        views.forEach({ $0?.alpha = 0})
        currentUserView.layer.cornerRadius = 120 / 2
        currentUserView.layer.borderWidth = 5
        currentUserView.layer.borderColor = UIColor.white.cgColor
        matchedUserView.layer.cornerRadius = 120 / 2
        matchedUserView.layer.borderWidth = 5
        matchedUserView.layer.borderColor = UIColor.white.cgColor
        
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
        
        sendMessageButton.isEnabled = false
        afterMessageButton.isEnabled = false
        sendMessageButton.layer.cornerRadius = 50 / 2
        afterMessageButton.layer.cornerRadius = 50 / 2
        afterMessageButton.backgroundColor = .clear
        afterMessageButton.layer.borderWidth = 2
        afterMessageButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
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

// MARK: - UITableViewDelegate
extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
        
        cell.user = self.user
        cell.configureCell(self.user)
        return cell
    }
}
