//
//  InboxTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class InboxCollectionViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var topBannerView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var backView: UIView!
    
    private var matches = [Match]()
    private var users = [User]()
    private var user = User()
    private var interstitial: GADInterstitial!
    private let refresh = UIRefreshControl()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "メッセージ"
        setupBanner()
        collectionView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        interstitial = createAndLoadIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.removeObject(forKey: CARDVC)
        segmentControl.selectedSegmentIndex = 0
        fetchMatchUsers()
        resetBadge()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc func refreshCollectionView(){
        fetchMatchUsers()
        refresh.endRefreshing()
    }
    
    // MARK: - Fetch
    
    private func fetchMatchUsers() {
        
        matches.removeAll()
        users.removeAll()
        collectionView.reloadData()
        
        Match.fetchMatchUser { (match) in
            guard let uid = match.uid else { return }
            self.fetchUser(uid: uid) {
                self.matches.append(match)
                self.collectionView.reloadData()
            }
        }
    }

    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    // MARK: - Helper
    
    private func resetBadge() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let totalAppBadgeCount = user.appBadgeCount - user.messageBadgeCount
            
            updateUser(withValue: [MESSAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
            UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
            self.tabBarController!.viewControllers![3].tabBarItem.badgeValue = nil
        }
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
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            backView.backgroundColor = UIColor(named: O_PINK)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            backView.backgroundColor = UIColor(named: O_GREEN)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            backView.backgroundColor = UIColor.white
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            backView.backgroundColor = UIColor(named: O_DARK)
            backView.alpha = 0.85
        }
    }
    
}


// MARK: - CollectionView

extension InboxCollectionViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MatchCollectionViewCell
        
        cell.configureCell(users[indexPath.row])
        cell.configureDateCell(matches[indexPath.row])
        cell.layer.cornerRadius = 10
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: matches[indexPath.row].uid)
    }
}

extension InboxCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        return NSAttributedString(string: "マッチしているお相手が、\nこちらに表示されます。", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "お互いがタイプになると\nマッチングが成立します。")
    }
}
