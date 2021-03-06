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
import JGProgressHUD
import CoreLocation
import Geofirestore

class DetailTableViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    
    // MARK: - Propertis
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBackView: UIView!
    @IBOutlet weak var typeBackView: UIView!
    @IBOutlet weak var likeBackView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var giftButtonView: UIView!
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
    @IBOutlet weak var descriptionLabel3: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var typeDoneLabel: UILabel!
    @IBOutlet weak var likeDoneLabel: UILabel!
    
    private var user = User()
    private var like = Like()
    private var type = Type()
    private var block = Block()
    private var favorite = Favorite()
    private var footstep = Footstep()
    public var userId = ""
    private var currentUser = User()
    private var typeUser = Type()
    private var interstitial: GADInterstitial!
    private var hud = JGProgressHUD(style: .dark)
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    lazy var views = [matchLabel, currentUserView, matchedUserView, sendMessageButton, afterMessageButton, congratsLabel, descriptionLabel, descriptionLabel2, descriptionLabel3]
    private let manager = CLLocationManager()
    private var userLat = ""
    private var userLong = ""
    private let geofirestroe = GeoFirestore(collectionRef: COLLECTION_GEO)
    private var myQuery: GFSQuery!
    private var distance: Double = 500
    private var currentLocation: CLLocation?
    private var community1 = Community()
    private var community2 = Community()
    private var community3 = Community()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        confifureLocationManager()
        interstitial = createAndLoadIntersitial()
//        interstitial = testIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCurrentUser()
        fetchUserId()
        fetchLikeUser()
        fetchTypeUser()
        fetchBlockUser()
        fetchIsFavorite()
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
    
    @IBAction func reportButtonPressed(_ sender: Any) {
        selectAlert()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "お気に入り", message: "アイテムを使用することでお気に入り登録できます", preferredStyle: .alert)
        let verification = UIAlertAction(title: "確認", style: .cancel)
        let caution = UIAlertAction(title: "お気に入り登録済みです", style: .cancel)
        let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
            
            updateUser(withValue: [ITEM9: self.currentUser.item9 - 1])
            let dict = [UID: self.user.uid as Any,
                        ISFAVORITE: true,
                        TIMESTAMP: Timestamp(date: Date())] as [String : Any]
            Favorite.saveFavorite(forUser: self.user, dict: dict)
            
            self.hud.show(in: self.view)
            self.hud.textLabel.text = "お気に入り登録しました"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        if favorite.isFavorite == true {
            alert.addAction(caution)
            self.present(alert,animated: true,completion: nil)
            return
        }
        
        if currentUser.item9 == 0 {
            alert.addAction(verification)
            self.present(alert,animated: true,completion: nil)
        } else {
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func giftButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "献上", message: "アイテムを使用しフリマポイントを送ります", preferredStyle: .alert)
        let verification = UIAlertAction(title: "確認", style: .cancel)
        let send: UIAlertAction = UIAlertAction(title: "送る", style: UIAlertAction.Style.default) { (alert) in
            self.hud.show(in: self.view)
            self.hud.textLabel.text = "献上しました"
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            self.incrementLikeCounter(ref: COLLECTION_LIKECOUNTER.document(User.currentUserId()), numShards: 10)
            self.incrementAppBadgeCount3()
            updateUser(withValue: [ITEM6: self.currentUser.item6 - 1])
            updateToUser(self.user.uid, withValue: [POINTS: self.user.points + 1])
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        if self.currentUser.item6 == 0 {
            alert.addAction(verification)
            self.present(alert,animated: true,completion: nil)
        } else {
            alert.addAction(send)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        showLikeAnimation()
        let dict = [UID: user.uid as Any,
                    ISLIKE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Like.saveIsLikeUser(forUser: user, isLike: dict)
        Like.saveLikedUser(forUser: user)
        incrementLikeCounter(ref: COLLECTION_LIKECOUNTER.document(user.uid), numShards: 10)
        incrementAppBadgeCount()
        updateUser(withValue: [MLIKECOUNT: currentUser.mLikeCount + 1])
        likeButton.isEnabled = false
        likeButton2.isEnabled = false
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        
        let dict = [UID: user.uid as Any,
                    ISTYPE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Type.saveIsTypeUser(forUser: user, isType: dict)
        Type.saveTypedUser(forUser: user)
        incrementTypeCounter(ref: COLLECTION_TYPECOUNTER.document(user.uid), numShards: 10)
        
        updateUser(withValue: [MTYPECOUNT: currentUser.mTypeCount + 1])
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
        checkIfMatch()
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
        footsteps(userId)
        
        User.fetchUser(userId) { (user) in
            self.user = user
            self.fetchCommunity1(self.user)
            self.fetchCommunity2(self.user)
            self.fetchCommunity3(self.user)
            self.tableView.reloadData()
        }
    }
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.currentUserView.sd_setImage(with: URL(string: self.currentUser.profileImageUrl1), completed: nil)
        }
    }
    
    private func fetchTypeUser() {
        
        guard userId != "" else { return }
        Type.fetchTypeUser(userId) { (type) in
            self.type = type
            self.validateTypeButton(type: type)
        }
    }
    
    private func fetchLikeUser() {
        
        guard userId != "" else { return }
        Like.fetchLikeUser(userId) { (like) in
            self.like = like
            self.validateLikeButton(like: like)
        }
    }
    
    private func fetchIsFavorite() {
        
        guard userId != "" else { return }
        Favorite.fetchIsFavariteUser(userId) { (favorite) in
            self.favorite = favorite
        }
    }
    
    private func checkIfMatch() {
        
        guard user.uid != nil else { return }
        Type.checkIfMatch(toUserId: userId) { [self] (type) in
            typeUser = type
            incrementAppBadgeCount2()
            
            if typeUser.isType == 1 {
                matchView()
                updateUser(withValue: [POINTS: currentUser.points + 1,
                                       MMATCHCOUNT: currentUser.mMatchCount + 1])
                updateToUser(user.uid, withValue: [POINTS: user.points + 1,
                                                   MMATCHCOUNT: user.mMatchCount + 1])
                Match.saveMatchUser(forUser: user)
                fetchCurrentUser()
            }
        }
    }
    
    private func fetchBlockUser() {
        
        guard userId != "" else { return }
        Block.fetchBlockUser(toUserId: userId) { (block) in
            self.block = block
        }
    }
    
    private func fetchCommunity1(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community1) { (community) in
            self.community1 = community
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity2(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community2) { (community) in
            self.community2 = community
            self.tableView.reloadData()
        }
    }
    
    private func fetchCommunity3(_ user: User) {
        
        Community.fetchCommunity(communityId: user.community3) { (community) in
            self.community3 = community
            self.tableView.reloadData()
        }
    }
    
    // MARK: - FootStep
    
    private func footsteps(_ toUserId: String) {
        
        Footstep.saveIsFootstepUser(toUserId: self.userId)
        if UserDefaults.standard.object(forKey: FOOTSTEP_ON) != nil {
            Footstep.saveFootstepedUser(toUserId: self.userId)
        }
        
        Footstep.fetchFootstepUser(toUserId) { (footstep) in
            self.footstep = footstep
            if footstep.uid == "" {
                self.visited(self.footstep)
                return
            }
            self.visited(self.footstep)
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let toUserId = sender as! String
            messageVC.toUserId = toUserId
        }
        
        if segue.identifier == "ReportVC" {
            let reportVC = segue.destination as! ReportTableViewController
            let userId = sender as! String
            reportVC.userId = userId
        }
        
        if segue.identifier == "BlockVC" {
            let blockVC = segue.destination as! BlockTableViewController
            let userId = sender as! String
            blockVC.userId = userId
        }
        
        if segue.identifier == "CommunityUsersVC" {
            let communityUsersVC = segue.destination as! CommunityUsersViewController
            let communityId = sender as! String
            communityUsersVC.communityId = communityId
        }
    }
    
    // MARK: - Google Ads
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/4674347886")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func testIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
    }
    
    // MARK: - Badge
    
    private func incrementAppBadgeCount() {
        sendRequestNotification2(toUser: self.user, message: "\(self.currentUser.username!)さんがいいねしてくれました", badge: self.user.appBadgeCount + 1)
        updateToUser(self.user.uid, withValue: [NEWLIKE: true])
    }
    
    private func incrementAppBadgeCount2() {
        
        if self.typeUser.isType == 1 {
            sendRequestNotification4(toUser: self.user, message: "マッチしました！メッセージを送ってみましょう！", badge: self.user.appBadgeCount + 1)
        } else {
            sendRequestNotification3(toUser: self.user, message: "誰かがタイプと言っています", badge: self.user.appBadgeCount + 1)
            updateToUser(self.user.uid, withValue: [NEWTYPE: true])
        }
    }
    
    private func incrementAppBadgeCount3() {
        sendRequestNotification5(toUser: self.user, message: "\(self.currentUser.username!)さんからプレゼントです", badge: self.user.appBadgeCount + 1)
    }
    
    // MARK: - Helpers
    
    private func confifureLocationManager() {
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    private func visited(_ footstep: Footstep) {
        
        if footstep.isFootStep != 1 {
            COLLECTION_USERS.document(userId).updateData([VISITED: self.user.visited + 1])
            User.fetchUser(User.currentUserId()) { (user) in
                self.currentUser = user
                updateUser(withValue: [MFOOTCOUNT: self.currentUser.mFootCount + 1])
            }
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
            self.performSegue(withIdentifier: "MessageVC", sender: self.user.uid)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        alert.addAction(logout)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
    }
    
    private func selectAlert() {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "\(user.username!)さんを", preferredStyle: .actionSheet)
        
        let block: UIAlertAction = UIAlertAction(title: "ブロックする", style: UIAlertAction.Style.default) { (alert) in
            self.performSegue(withIdentifier: "BlockVC", sender: self.user.uid)
        }
        let report: UIAlertAction = UIAlertAction(title: "通報する", style: UIAlertAction.Style.default) { (alert) in
            self.performSegue(withIdentifier: "ReportVC", sender: self.user.uid)
        }
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        
        if self.block.isBlock == 1 {
            alert.addAction(report)
            alert.addAction(cancel)
        } else {
            alert.addAction(block)
            alert.addAction(report)
            alert.addAction(cancel)
        }
        self.present(alert,animated: true,completion: nil)
    }
    
    private func setupUI() {
        
        if UserDefaults.standard.object(forKey: CARDVC) != nil {
            buttonStackView.isHidden = true
            reportButton.isHidden = true
        } else {
            buttonStackView.isHidden = false
            reportButton.isHidden = false
        }
        
        typeDoneLabel.isHidden = true
        likeDoneLabel.isHidden = true
        
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
        giftButtonView.layer.cornerRadius = 55 / 2
        
        likeBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        likeBackView.layer.shadowColor = UIColor.black.cgColor
        likeBackView.layer.shadowOpacity = 0.3
        likeBackView.layer.shadowRadius = 4
        
        typeBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        typeBackView.layer.shadowColor = UIColor.black.cgColor
        typeBackView.layer.shadowOpacity = 0.3
        typeBackView.layer.shadowRadius = 4
        
        giftButtonView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        giftButtonView.layer.shadowColor = UIColor.black.cgColor
        giftButtonView.layer.shadowOpacity = 0.3
        giftButtonView.layer.shadowRadius = 4
        
        messageBackView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        messageBackView.layer.shadowColor = UIColor.black.cgColor
        messageBackView.layer.shadowOpacity = 0.3
        messageBackView.layer.shadowRadius = 4
        
        sendMessageButton.isEnabled = false
        afterMessageButton.isEnabled = false
        sendMessageButton.layer.cornerRadius = 44 / 2
        afterMessageButton.layer.cornerRadius = 44 / 2
        afterMessageButton.backgroundColor = .clear
        afterMessageButton.layer.borderWidth = 2
        afterMessageButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
    }
    
    private func validateLikeButton(like: Like) {
        
        if like.isLike == 1 {
            likeButton.isEnabled = false
            likeButton2.isEnabled = false
            likeDoneLabel.isHidden = false
        } else {
            likeButton.isEnabled = true
            likeButton2.isEnabled = true
            likeDoneLabel.isHidden = true
        }
    }
    
    private func validateTypeButton(type: Type) {
        
        if type.isType == 1 {
            typeButton.isEnabled = false
            typeButton2.isEnabled = false
            typeDoneLabel.isHidden = false
            
        } else {
            typeButton.isEnabled = true
            typeButton2.isEnabled = true
            typeDoneLabel.isHidden = true
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
        
        cell.detailVC = self
        cell.user = self.user
        cell.currentUser = self.currentUser
        cell.configureCell(self.user)
        cell.currentLocation(self.user, self.currentLocation)
        cell.configureCommunity1(self.user, self.community1)
        cell.configureCommunity2(self.user, self.community2)
        cell.configureCommunity3(self.user, self.community3)
        return cell
    }
}

// MARK: - CLLocationManagerDelegate

extension DetailTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error location: \(error.localizedDescription) ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let updateLocation: CLLocation = locations.first!
        self.currentLocation = updateLocation
    }
}
