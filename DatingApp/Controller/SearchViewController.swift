//
//  SearchViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import EmptyDataSet_Swift

class SearchViewController: UIViewController {
    
    // MARK:  - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var users = [User]()
    private var user = User()
    private var currentUser = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
        Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")

        setupBanner()
        cofigureCollectionView()
        fetchBadgeCount()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.removeObject(forKey: CARDVC)
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchUser()
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
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
    }
    
    // MARK: - Actions
    
    @objc func refreshCollectionView(){
        fetchUser()
        refresh.endRefreshing()
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        fetchUser()
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
        
        User.fetchTabBarBadgeCount() { (user) in
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
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func cofigureCollectionView() {
        navigationItem.title = "さがす"
        collectionView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
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

extension SearchViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == 14 || indexPath.row == 28 || indexPath.row == 42 || indexPath.row == 56 || indexPath.row == 70 || indexPath.row == 84 || indexPath.row == 98 {
            return CGSize(width: 300, height: 250)
        }
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count == 0 ? 0 : 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 || indexPath.row == 14 || indexPath.row == 28 || indexPath.row == 42 || indexPath.row == 56 || indexPath.row == 70 || indexPath.row == 84 || indexPath.row == 98 {
            
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath)
            
            let bannerView = cell2.viewWithTag(1) as! GADBannerView
            bannerView.layer.cornerRadius = 15
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
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

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: "検索条件の結果から\n登録しているユーザーは\n見つかりませんでした。", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "ユーザーが登録されるまで\n暫くお待ちになるか、\n検索条件を変更してみてください。")
    }
}
