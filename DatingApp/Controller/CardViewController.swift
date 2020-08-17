//
//  CardViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/08.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class CardViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var cardStack: UIView!
    @IBOutlet weak var typeButtonView: UIView!
    @IBOutlet weak var likeButtonView: UIView!
    @IBOutlet weak var nopeButtonView: UIView!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var currentUserView: UIImageView!
    @IBOutlet weak var matchedUserView: UIImageView!
    @IBOutlet weak var afterMessageButton: UIButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyLabel2: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var tutorialSwipeView: UIView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var nopeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    private var cards = [Card]()
    private var users = [User]()
    private var user: User?
    private var typeUser = Type()
    private var interstitial: GADInterstitial!
    private var cardInitialLocationCenter: CGPoint!
    private var panInitialLocation: CGPoint!

    lazy var views = [matchLabel, currentUserView, matchedUserView, descriptionLabel, descriptionLabel2, afterMessageButton, congratsLabel]
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBanner()
        showTutorialView()
        interstitial = createAndLoadIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        UserDefaults.standard.set(true, forKey: CARDVC)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        emptyLabel.isHidden = true
        emptyLabel2.isHidden = true
        loadView()
        setupUI()
        fetchUser()
        setupBanner()
        users.removeAll()
        cards.removeAll()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toModalSearchVC = storyboard.instantiateViewController(withIdentifier: "ModalSearchVC")
        self.present(toModalSearchVC, animated: true, completion: nil)
    }
    
    @IBAction func typeButtonPressed(_ sender: Any) {
        guard let firstCard = cards.first else { return }
        
        let dict = [UID: firstCard.user?.uid! as Any,
                    ISTYPE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Type.saveIsTypeUser(forUser: firstCard.user!, isType: dict)
        Type.saveTypedUser(forUser: firstCard.user!)
        incrementTypeCounter(ref: COLLECTION_TYPECOUNTER.document(firstCard.user.uid), numShards: 10)
        Service.saveSwipe(toUserId: firstCard.user.uid)
        
        checkIfMatch(firstCard.user.uid, cardUser: firstCard.user)
        swipeAnimationY(translation: 1000)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if UserDefaults.standard.object(forKey: FEMALE) == nil {
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                }
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        guard let firstCard = cards.first else { return }
        
        let dict = [UID: firstCard.user?.uid! as Any,
                    ISLIKE: 1,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Like.saveIsLikeUser(forUser: firstCard.user!, isLike: dict)
        Like.saveLikedUser(forUser: firstCard.user!)
        incrementLikeCounter(ref: COLLECTION_LIKECOUNTER.document(firstCard.user.uid), numShards: 10)
        incrementAppBadgeCount()
        Service.saveSwipe(toUserId: firstCard.user.uid)
        
        swipeAnimationX(translation: 750)
    }
    
    @IBAction func nopeButtonPressed(_ sender: Any) {
        guard let firstCard = cards.first else { return }
        
        let dict = [UID: firstCard.user?.uid! as Any,
                    ISLIKE: 0,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Like.saveIsLikeUser(forUser: firstCard.user!, isLike: dict)
        Service.saveSwipe(toUserId: firstCard.user.uid)
        swipeAnimationX(translation: -750)
    }
    
    @IBAction func afterSendButtonPressed(_ sender: Any) {
        removeEffectView()
    }
    
    @objc func handleDismissal() {
        removeEffectView()
    }
    
    @objc func handleDismissal2() {
        removeEffectView2()
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        
        let card = gesture.view! as! Card
        let translation = gesture.translation(in: cardStack)
        
        switch gesture.state {
        case .began:
            panInitialLocation = gesture.location(in: cardStack)
            
        case .changed:
            card.center.x = cardInitialLocationCenter.x + translation.x
            card.center.y = cardInitialLocationCenter.y + translation.y
            
            if translation.x > 0 {
                card.likeView.alpha = abs(translation.x * 2) / cardStack.bounds.midX / 3
                card.nopeView.alpha = 0
                card.typeView.alpha = 0
            }
            if translation.x < 0 {
                card.nopeView.alpha = abs(translation.x * 2) / cardStack.bounds.midX / 3
                card.likeView.alpha = 0
                card.typeView.alpha = 0
            }
            if translation.y > 0 && translation.x < 50 && translation.x > -50 {
                card.typeView.alpha = abs(translation.y * 2) / cardStack.bounds.midY / 3
                card.likeView.alpha = 0
                card.nopeView.alpha = 0
            }
            
        case .ended:
            if translation.x > 150 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x + 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    card.removeFromSuperview()
                }
                let dict = [UID: card.user?.uid! as Any,
                            ISLIKE: 1,
                            TIMESTAMP: Timestamp(date: Date())] as [String : Any]
                
                Like.saveIsLikeUser(forUser: card.user!, isLike: dict)
                Like.saveLikedUser(forUser: card.user!)
                incrementLikeCounter(ref: COLLECTION_LIKECOUNTER.document(card.user.uid), numShards: 10)
                incrementAppBadgeCount()
                Service.saveSwipe(toUserId: card.user.uid)
                
                self.updateCards(card: card)
                return
                
            } else if translation.x < -150 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: self.cardInitialLocationCenter.x - 1000, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    card.removeFromSuperview()
                }
                let dict = [UID: card.user?.uid! as Any,
                            ISLIKE: 0,
                            TIMESTAMP: Timestamp(date: Date())] as [String : Any]
                
                Like.saveIsLikeUser(forUser: card.user!, isLike: dict)
                Service.saveSwipe(toUserId: card.user.uid)
                
                self.updateCards(card: card)
                return
                
            } else if translation.y > 200 && translation.x < 50 && translation.x > -50 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: 0, y: self.cardInitialLocationCenter.y + 1000)
                }) { (bool) in
                    card.removeFromSuperview()
                }
                let dict = [UID: card.user?.uid! as Any,
                            ISTYPE: 1,
                            TIMESTAMP: Timestamp(date: Date())] as [String : Any]
                
                Type.saveIsTypeUser(forUser: card.user!, isType: dict)
                Type.saveTypedUser(forUser: card.user!)
                incrementTypeCounter(ref: COLLECTION_TYPECOUNTER.document(card.user.uid), numShards: 10)
                Service.saveSwipe(toUserId: card.user.uid)
                
                checkIfMatch(card.user.uid, cardUser: card.user)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if UserDefaults.standard.object(forKey: FEMALE) == nil {
                        if self.interstitial.isReady {
                            self.interstitial.present(fromRootViewController: self)
                        } else {
                            print("Error interstitial")
                        }
                    }
                }
                self.updateCards(card: card)
                return
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                card.center = self.cardInitialLocationCenter
                card.likeView.alpha = 0
                card.nopeView.alpha = 0
                card.typeView.alpha = 0
            }, completion: nil)
            
        default:
            break
        }
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        indicator.startAnimating()
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.currentUserView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
            self.fetchUsers(user)
        }
    }
    
    private func fetchUsers(_ user: User) {
        
        if user.residenceSerch == "こだわらない" {
            User.fetchCardAllUsers(user) { (user) in
                if user.uid == "" {
                    self.indicator.stopAnimating()
                    self.emptyLabel.isHidden = false
                    self.emptyLabel2.isHidden = false
                    return
                }
                self.users.append(user)
                self.setupCards(user: user)
            }
        } else {
            User.fetchCardUsers(user.residenceSerch, user) { (user) in
                if user.uid == "" {
                    self.indicator.stopAnimating()
                    self.emptyLabel.isHidden = false
                    self.emptyLabel2.isHidden = false
                    return
                }
                self.users.append(user)
                self.setupCards(user: user)
            }
        }
    }
    
    private func checkIfMatch(_ userId: String, cardUser: User) {
        
        Type.checkIfMatch(toUserId: userId) { (type) in
            self.typeUser = type
            
            if self.typeUser.isType == 1 {
                self.matchView(cardUser: cardUser)
                Match.saveMatchUser(forUser: cardUser)
                sendRequestNotification4(toUser: cardUser, message: "マッチしました！メッセージを送ってみましょう！", badge: (cardUser.appBadgeCount)! + 1)
                
            } else {
                sendRequestNotification3(toUser: cardUser, message: "誰かがタイプと言っています", badge: cardUser.appBadgeCount + 1)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.views.forEach({ $0?.alpha = 0 })
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    private func removeEffectView2() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.tutorialSwipeView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: TUTORIAL_END)
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
    
    private func incrementAppBadgeCount() {
        guard let firstCard = cards.first else { return }
        sendRequestNotification2(toUser: firstCard.user, message: "\(self.user!.username!)さんがいいねしてくれました", badge: firstCard.user.appBadgeCount + 1)
    }
    
    private func updateCards(card: Card) {
        
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == card.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        setupGestures()
    }
    
    private func setupGestures() {
        
        for card in cards {
            let gesture = card.gestureRecognizers ?? []
            for g in gesture {
                card.removeGestureRecognizer(g)
            }
        }
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    private func swipeAnimationX(translation: CGFloat) {
        
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        guard let firstCard = cards.first else { return }
        
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == firstCard.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        self.setupGestures()
        CATransaction.setCompletionBlock {
            firstCard.removeFromSuperview()
        }
        firstCard.layer.add(translationAnimation, forKey: "translation")
        CATransaction.commit()
    }
    
    private func swipeAnimationY(translation: CGFloat) {
        
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.y")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        guard let firstCard = cards.first else { return }
        
        for (index, c) in self.cards.enumerated() {
            if c.user.uid == firstCard.user.uid {
                self.cards.remove(at: index)
                self.users.remove(at: index)
            }
        }
        self.setupGestures()
        CATransaction.setCompletionBlock {
            firstCard.removeFromSuperview()
        }
        firstCard.layer.add(translationAnimation, forKey: "translation")
        CATransaction.commit()
    }
    
    private func setupCards(user: User) {
        
        let card: Card = UIView.fromNib()
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.user = user
        card.cardVC = self
        card.configureCell(user)
        cards.append(card)
        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
        indicator.stopAnimating()
        emptyLabel.isHidden = false
        emptyLabel2.isHidden = false
        if cards.count == 1 {
            cardInitialLocationCenter = card.center
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    private func setupUI() {
        
        emptyLabel.text = "スワイプできるカードは\nありません。"
        emptyLabel2.text = "暫くお待ちになるか、\n検索条件を変更してみてください。"
        emptyLabel2.textColor = .systemGray
        navigationItem.title = "カードからさがす"
        likeButtonView.layer.cornerRadius = 55 / 2
        typeButtonView.layer.cornerRadius = 55 / 2
        nopeButtonView.layer.cornerRadius = 55 / 2
        placeholderImageView.layer.cornerRadius = 15
        tutorialSwipeView.layer.cornerRadius = 15
        tutorialSwipeView.alpha = 0
        
        likeLabel.backgroundColor = .systemOrange
        nopeLabel.backgroundColor = .systemIndigo
        typeLabel.backgroundColor = .systemPink
        likeLabel.layer.cornerRadius = 31.5 / 2
        nopeLabel.layer.cornerRadius = 31.5 / 2
        typeLabel.layer.cornerRadius = 30 / 2
        
        likeButtonView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        likeButtonView.layer.shadowColor = UIColor.black.cgColor
        likeButtonView.layer.shadowOpacity = 0.3
        likeButtonView.layer.shadowRadius = 4
        typeButtonView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        typeButtonView.layer.shadowColor = UIColor.black.cgColor
        typeButtonView.layer.shadowOpacity = 0.3
        typeButtonView.layer.shadowRadius = 4
        nopeButtonView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        nopeButtonView.layer.shadowColor = UIColor.black.cgColor
        nopeButtonView.layer.shadowOpacity = 0.3
        nopeButtonView.layer.shadowRadius = 4
        
        afterMessageButton.isEnabled = false
        afterMessageButton.layer.cornerRadius = 50 / 2
        afterMessageButton.backgroundColor = .clear
        afterMessageButton.layer.borderWidth = 2
        afterMessageButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        views.forEach({ $0?.alpha = 0})
        descriptionLabel.textColor  = .white
        descriptionLabel2.textColor  = .white
        matchLabel.textColor = .white
        congratsLabel.textColor = .white
        currentUserView.layer.cornerRadius = 120 / 2
        currentUserView.layer.borderWidth = 5
        currentUserView.layer.borderColor = UIColor.white.cgColor
        matchedUserView.layer.cornerRadius = 120 / 2
        matchedUserView.layer.borderWidth = 5
        matchedUserView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func matchView(cardUser: User) {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(tap)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.visualEffectView.frame = self.view.frame
            self.view.addSubview(self.visualEffectView)
            self.visualEffectView.alpha = 0
            self.views.forEach { (view) in
                self.view.addSubview(view!)
            }
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.visualEffectView.alpha = 1
                self.views.forEach({ $0?.alpha = 1})
                self.views.forEach({ $0?.isHidden = false})
                self.configureAnimations()
                self.afterMessageButton.isEnabled = true
                self.matchLabel.text = "\(cardUser.username!)さんとマッチしました！"
                self.matchedUserView.sd_setImage(with: URL(string: cardUser.profileImageUrl1), completed: nil)
            }, completion: nil)
        }
    }
    
    private func showTutorialView() {
        
        if UserDefaults.standard.object(forKey: TUTORIAL_END) == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal2))
            visualEffectView.addGestureRecognizer(tap)
            tutorialSwipeView.addGestureRecognizer(tap)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                self.visualEffectView.frame = self.view.frame
                self.view.addSubview(self.visualEffectView)
                self.visualEffectView.alpha = 0
                self.view.addSubview(self.tutorialSwipeView)
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.visualEffectView.alpha = 1
                    self.tutorialSwipeView.alpha = 1
                    
                }, completion: nil)
            }
        }
    }
    
    func configureAnimations() {
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        matchedUserView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        self.afterMessageButton.transform = CGAffineTransform(translationX: 0, y: 500)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserView.transform = .identity
                self.matchedUserView.transform = .identity
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.afterMessageButton.transform = .identity
        }, completion: nil)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
    }
}
