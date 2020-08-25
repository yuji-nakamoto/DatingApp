//
//  SearchCollectionViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import EmptyDataSet_Swift

class SearchCollectionViewController: UIViewController {
    
    // MARK:  - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var lankView: UIView!
    @IBOutlet weak var likeLankButton: UIButton!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchMiniButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginBunusView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: RCOMPLETION)
        Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")
        
        fetchUser()
        setupBanner()
        checkOneDayAndBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        UserDefaults.standard.removeObject(forKey: CARDVC)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        collectionView.reloadData()
        if !Auth.auth().currentUser!.uid.isEmpty {
            if UserDefaults.standard.object(forKey: LIKE_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "like\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: TYPE_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "type\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: MESSAGE_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "message\(Auth.auth().currentUser!.uid)")
            }
            if UserDefaults.standard.object(forKey: MATCH_ON) != nil {
                Messaging.messaging().subscribe(toTopic: "match\(Auth.auth().currentUser!.uid)")
            }
        }
        
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchUsers(user)
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func miniCollectionButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI) == nil {
            UserDefaults.standard.set(true, forKey: SEARCH_MINI)
            searchMiniButton.setImage(UIImage(systemName: "circle.grid.2x2.fill"), for: .normal)
            fetchUsers(user)
        } else {
            UserDefaults.standard.removeObject(forKey: SEARCH_MINI)
            searchMiniButton.setImage(UIImage(systemName: "square.grid.4x3.fill"), for: .normal)
            fetchUsers(user)
        }
    }
    
    @objc func handleDismissal() {
        removeEffectView()
    }
    
    @objc func refreshCollectionView(){
        fetchUsers(user)
    }
    
    @IBAction func likelankButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.lankView.isHidden = !self.lankView.isHidden
        }
    }
    
    @IBAction func segmentControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: break
        case 1: performSegue(withIdentifier: "LikeNationVC", sender: nil)
        case 2: performSegue(withIdentifier: "LikeCountVC", sender: nil)
        default: break
        }
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.fetchUsers(self.user)
            self.collectionView.reloadData()
            
            if self.user.gender == "女性" {
                UserDefaults.standard.set(true, forKey: FEMALE)
            } else {
                UserDefaults.standard.removeObject(forKey: FEMALE)
            }
        }
    }
    
    private func fetchUsers(_ user: User) {
        indicator.startAnimating()
        
        let residence = user.residenceSerch
        if residence == "こだわらない" {
            User.fetchNationwide(user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
            }
        } else {
            User.fetchUserResidenceSort(residence!, user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
                self.refresh.endRefreshing()
            }
        }
    }
    
    private func checkOneDayAndBadge() {
        
        User.fetchUserAddSnapshotListener() { (user) in
            self.user = user
            
            if self.user.messageBadgeCount == 0 {
                self.tabBarController?.viewControllers?[3].tabBarItem?.badgeValue = nil
            } else {
                self.tabBarController?.viewControllers?[3].tabBarItem?.badgeValue = String(self.user.messageBadgeCount)
            }
            
            if self.user.myPageBadgeCount == 0 {
                self.tabBarController?.viewControllers?[4].tabBarItem?.badgeValue = nil
            } else {
                self.tabBarController?.viewControllers?[4].tabBarItem?.badgeValue = String(self.user.myPageBadgeCount)
            }
            
            if self.user.oneDay == true {
                updateUser(withValue: [POINTS: self.user.points + 1, ONEDAY: false])
                self.showLoginBunusView()
            }
        }
    }
    
    // MARK: - Heplers
    
    private func showLoginBunusView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(tap)
        
        visualEffectView.frame = self.view.frame
        visualEffectView.alpha = 0
        view.addSubview(self.visualEffectView)
        view.addSubview(self.loginBunusView)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
            self.loginBunusView.alpha = 1
            
        }, completion: nil)
    }
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.loginBunusView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func configure() {
        
        segmentControl.selectedSegmentIndex = 0
        loginBunusView.alpha = 0
        lankView.alpha = 0.85
        navBarView.alpha = 0.85
        loginBunusView.layer.cornerRadius = 15
        likeLankButton.layer.cornerRadius = 27 / 2
        collectionView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        if UserDefaults.standard.object(forKey: LANKBAR) != nil {
            lankView.isHidden = false
        }
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            likeLankButton.backgroundColor = .white
            likeLankButton.setTitleColor(UIColor(named: O_PINK), for: .normal)
            titleLabel.textColor = .white
            searchButton.tintColor = .white
            searchMiniButton.tintColor = .white
            navBarView.backgroundColor = UIColor(named: O_PINK)
            lankView.backgroundColor = UIColor(named: O_PINK)
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            likeLankButton.backgroundColor = UIColor.white
            likeLankButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            titleLabel.textColor = UIColor.white
            searchButton.tintColor = UIColor.white
            searchMiniButton.tintColor = UIColor.white
            navBarView.backgroundColor = UIColor(named: O_GREEN)
            lankView.backgroundColor = UIColor(named: O_GREEN)
            
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            likeLankButton.backgroundColor = UIColor(named: O_GREEN)
            likeLankButton.setTitleColor(UIColor.white, for: .normal)
            titleLabel.textColor = UIColor(named: O_BLACK)
            searchButton.tintColor = UIColor(named: O_BLACK)
            searchMiniButton.tintColor = UIColor(named: O_BLACK)
            navBarView.backgroundColor = .white
            lankView.backgroundColor = .white
            
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            likeLankButton.backgroundColor = .white
            likeLankButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            titleLabel.textColor = .white
            searchButton.tintColor = .white
            searchMiniButton.tintColor = .white
            navBarView.backgroundColor = UIColor(named: O_DARK)
            lankView.backgroundColor = UIColor(named: O_DARK)
        }
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI) != nil {
            searchMiniButton.setImage(UIImage(systemName: "circle.grid.2x2.fill"), for: .normal)
        } else {
            searchMiniButton.setImage(UIImage(systemName: "square.grid.4x3.fill"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
}

//MARK: CollectionView

extension SearchCollectionViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI) != nil {
            return UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI) != nil {
            return 10
        }
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            return CGSize(width: 300, height: 250)
        }
        
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count == 0 ? 0 : 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath)
            
            let bannerView = cell3.viewWithTag(1) as! GADBannerView
            bannerView.layer.cornerRadius = 15
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            //            bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
            return cell3
        }
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI) != nil {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! SearchCollectionViewCell
            
            cell2.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell2.layer.shadowColor = UIColor.black.cgColor
            cell2.layer.shadowOpacity = 0.3
            cell2.layer.shadowRadius = 4
            cell2.layer.masksToBounds = false
            cell2.configureMiniCell(users[indexPath.row - 1])
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(users[indexPath.row - 1])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1].uid)
    }
}

extension SearchCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: "検索条件の結果から\n登録しているユーザーは\n見つかりませんでした。", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "ユーザーが登録されるまで\n暫くお待ちになるか、\n検索条件を変更してみてください。")
    }
}
