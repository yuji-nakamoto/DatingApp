//
//  NewUserCollectionViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/04.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import NVActivityIndicatorView

class NewUserCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    private var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        testBanner()
        
        setupIndicator()
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
        
        users.removeAll()
        collectionView.reloadData()
        if UserDefaults.standard.object(forKey: REFRESH_ON) == nil {
            showLoadingIndicator()
        }
        
        User.fetchNewUserSort(user) { (users) in
            self.users = users
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
            self.hideLoadingIndicator()
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
    
    private func setupIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 250, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
    }
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
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

extension NewUserCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
//            cell3.bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
//            cell3.bannerView.rootViewController = self
//            cell3.bannerView.load(GADRequest())
            cell3.testBanner3()
            cell3.newUserCVC = self
            
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

extension NewUserCollectionViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "ユーザーは見つかりませんでした", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "しばらくお待ちになるか、\n検索条件を変更してみてください", attributes: attributes)
    }
}
