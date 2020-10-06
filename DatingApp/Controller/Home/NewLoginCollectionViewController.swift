//
//  NewLoginCollectionViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class NewLoginCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
//        testBanner()
        
        addSnapshotListener()
        fetchUser()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchUsers(user)
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    @objc func refreshCollectionView(){
        UserDefaults.standard.set(true, forKey: REFRESH_ON)
        fetchUsers(self.user)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.fetchUsers(self.user)
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUsers(_ user: User) {
        
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            indicator.startAnimating()
        }
        
        User.fetchNewLoginSort(user) { (users) in
            self.users = users
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
            self.indicator.stopAnimating()
            UserDefaults.standard.removeObject(forKey: REFRESH_ON)
        }
    }
    
    private func addSnapshotListener() {
        
        User.fetchUserAddSnapshotListener() { (user) in
            self.user = user
            self.fetchUsers(self.user)
        }
    }
    
    // MARK: - Helper
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        collectionView.refreshControl = refresh
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
}

//MARK: CollectionView

extension NewLoginCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            return UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        }
        return UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            return 10
        }
        return 25
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            return users.count == 0 ? 0 : users.count
        }
        return users.count == 0 ? 0 : 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) == nil && indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! SearchCollectionViewCell
            cell3.bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
            cell3.bannerView.rootViewController = self
            cell3.bannerView.load(GADRequest())
//            cell3.testBanner2()
            cell3.newLoginCVC = self
            
            return cell3
        }
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! SearchCollectionViewCell
            
            cell2.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell2.layer.shadowColor = UIColor.black.cgColor
            cell2.layer.shadowOpacity = 0.3
            cell2.layer.shadowRadius = 4
            cell2.layer.masksToBounds = false
            if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
                cell2.configureMiniCell(users[indexPath.row])
                return cell2
            }
            cell2.configureMiniCell(users[indexPath.row - 1])
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(users[indexPath.row - 1])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row].uid)
            return
        }
        if indexPath.row != 0 {
            performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1].uid)
        }
    }
}

extension NewLoginCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: "ユーザーは見つかりませんでした", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "しばらくお待ちになるか、\n検索条件を変更してみてください")
    }
}
