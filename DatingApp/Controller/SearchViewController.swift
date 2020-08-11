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
        
        setupBanner()
        cofigureCollectionView()
        fetchBadgeCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        
        UserDefaults.standard.removeObject(forKey: CARDVC)
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchUser()
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !Auth.auth().currentUser!.uid.isEmpty {
            Messaging.messaging().subscribe(toTopic: Auth.auth().currentUser!.uid)
            print("messaging subscribe")
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
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            let residence = self.currentUser.residenceSerch
            
            User.genderAndResidenceSort(residence!, self.currentUser) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
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
            detailVC.user = sender as! User
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
}

//MARK: CollectionView

extension SearchViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 || indexPath.row == 9 || indexPath.row == 18 || indexPath.row == 27 || indexPath.row == 36 {
            return CGSize(width: 300, height: 250)
        }
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count == 0 ? 0 : 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 || indexPath.row == 9 || indexPath.row == 18 || indexPath.row == 27 || indexPath.row == 36 {
            
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
        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1])
    }
}

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        return NSAttributedString(string: "検索条件の結果から\n登録しているユーザーは\n見つかりませんでした。", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "ユーザーが登録されるまで\n暫くお待ちになるか、\n検索条件を変更してみてください。")
    }
}
