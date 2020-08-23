//
//  SearchMinimumCollectionViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import EmptyDataSet_Swift

class SearchMinimumCollectionViewController: UIViewController {
    
    // MARK:  - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var lankView: UIView!
    @IBOutlet weak var likeLankButton: UIButton!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchDefaultButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var users = [User]()
    private var currentUser = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: RCOMPLETION)
        UserDefaults.standard.set(true, forKey: SEARCH_MINI)
        Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")

        setupBanner()
        fetchBadgeCount()
        fetchUser()
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
            fetchUser()
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    // MARK: - Actions
    
    @objc func refreshCollectionView(){
        fetchUser()
        refresh.endRefreshing()
    }
    
    @IBAction func likelankButtonPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.lankView.isHidden = !self.lankView.isHidden
        }
    }
    
    @IBAction func searchDefaultButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: SEARCH_MINI)
        toSearchVC()
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
        indicator.startAnimating()
        users.removeAll()
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            if self.currentUser.gender == "女性" {
                UserDefaults.standard.set(true, forKey: FEMALE)
            } else {
                UserDefaults.standard.removeObject(forKey: FEMALE)
            }
            
            let residence = self.currentUser.residenceSerch
            if residence == "こだわらない" {
                User.fetchNationwide(self.currentUser) { (users) in
                    self.users = users
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            } else {
                User.genderAndResidenceSort(residence!, self.currentUser) { (users) in
                    self.users = users
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    private func fetchBadgeCount() {
        
        User.fetchUserAddSnapshotListener() { (user) in
            self.currentUser = user
            
            if self.currentUser.messageBadgeCount == 0 {
                self.tabBarController!.viewControllers![3].tabBarItem?.badgeValue = nil
            } else {
                self.tabBarController!.viewControllers![3].tabBarItem?.badgeValue = String(self.currentUser.messageBadgeCount)
            }
            
            if self.currentUser.myPageBadgeCount == 0 {
                self.tabBarController!.viewControllers![4].tabBarItem?.badgeValue = nil
            } else {
                self.tabBarController!.viewControllers![4].tabBarItem?.badgeValue = String(self.currentUser.myPageBadgeCount)
            }
        }
    }
    
    // MARK: - Heplers
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func configure() {
        
        lankView.alpha = 0.85
        navBarView.alpha = 0.85
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
            searchDefaultButton.tintColor = .white
            navBarView.backgroundColor = UIColor(named: O_PINK)
            lankView.backgroundColor = UIColor(named: O_PINK)
            
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            likeLankButton.backgroundColor = UIColor(named: O_BLACK)
            likeLankButton.setTitleColor(UIColor(named: O_GREEN), for: .normal)
            titleLabel.textColor = UIColor(named: O_BLACK)
            searchButton.tintColor = UIColor(named: O_BLACK)
            searchDefaultButton.tintColor = UIColor(named: O_BLACK)
            navBarView.backgroundColor = UIColor(named: O_GREEN)
            lankView.backgroundColor = UIColor(named: O_GREEN)

        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            likeLankButton.backgroundColor = UIColor(named: O_GREEN)
            likeLankButton.setTitleColor(UIColor.white, for: .normal)
            titleLabel.textColor = UIColor(named: O_BLACK)
            searchButton.tintColor = UIColor(named: O_BLACK)
            searchDefaultButton.tintColor = UIColor(named: O_BLACK)
            navBarView.backgroundColor = .white
            lankView.backgroundColor = .white

        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            likeLankButton.backgroundColor = .white
            likeLankButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            titleLabel.textColor = .white
            searchButton.tintColor = .white
            searchDefaultButton.tintColor = .white
            navBarView.backgroundColor = UIColor(named: O_DARK)
            lankView.backgroundColor = UIColor(named: O_DARK)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    private func toSearchVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toSearchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        navigationController?.pushViewController(toSearchVC, animated: false)
    }
}

//MARK: CollectionView

extension SearchMinimumCollectionViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            return CGSize(width: 80, height: 105)
        }
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count == 0 ? 0 : 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath)
            
            let bannerView = cell2.viewWithTag(1) as! GADBannerView
            bannerView.layer.cornerRadius = 15
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//            bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        
        cell.layer.cornerRadius = 6
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        cell.configureMiniCell(users[indexPath.row - 1])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1].uid)
    }
}

extension SearchMinimumCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: "検索条件の結果から\n登録しているユーザーは\n見つかりませんでした。", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "ユーザーが登録されるまで\n暫くお待ちになるか、\n検索条件を変更してみてください。")
    }
}
