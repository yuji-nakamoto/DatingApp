//
//  SearchViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class SearchViewController: UIViewController {
    
    // MARK:  - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var users = [User]()
    private var user: User?
    private var currentUser: User!
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanner()
        fetchUser()
        cofigureCollectionView()
        fetchBadgeCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        self.viewDidLoad()
        fetchUser()
    }
    
    @objc func refreshCollectionView(){
        fetchUser()
        refresh.endRefreshing()
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        indicator.startAnimating()
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let residenceSerch = user.residenceSerch
            User.genderAndResidenceSort(residenceSerch!, user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }
    
    private func fetchBadgeCount() {
        
        User.fetchTabBarBadgeCount(forCurrentId: User.currentUserId()) { (user) in
            self.currentUser = user
            
            if self.currentUser.messageBadgeCount == 0 {
                self.tabBarController!.viewControllers![2].tabBarItem?.badgeValue = nil
            } else {
                self.tabBarController!.viewControllers![2].tabBarItem?.badgeValue = String(self.currentUser.messageBadgeCount)
            }
            
            if self.currentUser.myPageBadgeCount == 0 {
                self.tabBarController!.viewControllers![3].tabBarItem?.badgeValue = nil
            } else {
                self.tabBarController!.viewControllers![3].tabBarItem?.badgeValue = String(self.currentUser.myPageBadgeCount)
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
        
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 5 || indexPath.row == 15 || indexPath.row == 25 || indexPath.row == 35 || indexPath.row == 45 {
            
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! AdsSearchCollectionViewCell
            
            cell2.searchVC = self
            cell2.setupBanner()
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row])
    }
}
