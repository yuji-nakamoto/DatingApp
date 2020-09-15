//
//  LikeCountSortViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class LikeCountSortViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        testBanner()
        fetchUser()
        setupUI()
        addSnapshotListener()
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
        let residence = user.residenceSerch
        if residence == "こだわらない" {
            User.likeCountSortNationwide(user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.refresh.endRefreshing()
                self.indicator.stopAnimating()
                UserDefaults.standard.removeObject(forKey: REFRESH_ON)
            }
        } else {
            User.likeCountSort(user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.refresh.endRefreshing()
                self.indicator.stopAnimating()
                UserDefaults.standard.removeObject(forKey: REFRESH_ON)
            }
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
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
}

//MARK: CollectionView

extension LikeCountSortViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count == 0 ? 0 : users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! SearchCollectionViewCell
            
            cell2.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            cell2.layer.shadowColor = UIColor.black.cgColor
            cell2.layer.shadowOpacity = 0.3
            cell2.layer.shadowRadius = 4
            cell2.layer.masksToBounds = false
            cell2.configureMiniCell(users[indexPath.row])
            
            if indexPath.row == 0 {
                cell2.miniNumberLabel.text = "1"
                cell2.miniNumberLabel.textColor = UIColor(named: "original_gold")
            } else if indexPath.row == 1 {
                cell2.miniNumberLabel.text = "2"
                cell2.miniNumberLabel.textColor = UIColor(named: "original_silver")
            } else if indexPath.row == 2 {
                cell2.miniNumberLabel.text = "3"
                cell2.miniNumberLabel.textColor = UIColor(named: "original_brown")
            } else if indexPath.row == 3 {
                cell2.miniNumberLabel.text = "4"
                cell2.miniNumberLabel.textColor = UIColor(named: O_BLACK)
            } else if indexPath.row == 4 {
                cell2.miniNumberLabel.text = "5"
            } else if indexPath.row == 5 {
                cell2.miniNumberLabel.text = "6"
            } else if indexPath.row == 6 {
                cell2.miniNumberLabel.text = "7"
            } else if indexPath.row == 7 {
                cell2.miniNumberLabel.text = "8"
            } else if indexPath.row == 8 {
                cell2.miniNumberLabel.text = "9"
            } else if indexPath.row == 9 {
                cell2.miniNumberLabel.text = "10"
            } else if indexPath.row == 10 {
                cell2.miniNumberLabel.text = "11"
            } else if indexPath.row == 11 {
                cell2.miniNumberLabel.text = "12"
            } else if indexPath.row == 12 {
                cell2.miniNumberLabel.text = "13"
            } else if indexPath.row == 13 {
                cell2.miniNumberLabel.text = "14"
            } else if indexPath.row == 14 {
                cell2.miniNumberLabel.text = "15"
            } else if indexPath.row == 15 {
                cell2.miniNumberLabel.text = "16"
            } else if indexPath.row == 16 {
                cell2.miniNumberLabel.text = "17"
            } else if indexPath.row == 17 {
                cell2.miniNumberLabel.text = "18"
            } else if indexPath.row == 18 {
                cell2.miniNumberLabel.text = "19"
            } else if indexPath.row == 20 {
                cell2.miniNumberLabel.text = "21"
            } else if indexPath.row == 21 {
                cell2.miniNumberLabel.text = "22"
            } else if indexPath.row == 22 {
                cell2.miniNumberLabel.text = "23"
            } else if indexPath.row == 23 {
                cell2.miniNumberLabel.text = "24"
            } else if indexPath.row == 24 {
                cell2.miniNumberLabel.text = "25"
            } else if indexPath.row == 25 {
                cell2.miniNumberLabel.text = "26"
            } else if indexPath.row == 26 {
                cell2.miniNumberLabel.text = "27"
            } else if indexPath.row == 27 {
                cell2.miniNumberLabel.text = "28"
            } else if indexPath.row == 28 {
                cell2.miniNumberLabel.text = "29"
            } else if indexPath.row == 29 {
                cell2.miniNumberLabel.text = "30"
            }
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(users[indexPath.row])
        
        if indexPath.row == 0 {
            cell.numberLabel.text = "1"
            cell.numberLabel.textColor = UIColor(named: "original_gold")
        } else if indexPath.row == 1 {
            cell.numberLabel.text = "2"
            cell.numberLabel.textColor = UIColor(named: "original_silver")
        } else if indexPath.row == 2 {
            cell.numberLabel.text = "3"
            cell.numberLabel.textColor = UIColor(named: "original_brown")
        } else if indexPath.row == 3 {
            cell.numberLabel.text = "4"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 4 {
            cell.numberLabel.text = "5"
        } else if indexPath.row == 5 {
            cell.numberLabel.text = "6"
        } else if indexPath.row == 6 {
            cell.numberLabel.text = "7"
        } else if indexPath.row == 7 {
            cell.numberLabel.text = "8"
        } else if indexPath.row == 8 {
            cell.numberLabel.text = "9"
        } else if indexPath.row == 9 {
            cell.numberLabel.text = "10"
        } else if indexPath.row == 10 {
            cell.numberLabel.text = "11"
        } else if indexPath.row == 11 {
            cell.numberLabel.text = "12"
        } else if indexPath.row == 12 {
            cell.numberLabel.text = "13"
        } else if indexPath.row == 13 {
            cell.numberLabel.text = "14"
        } else if indexPath.row == 14 {
            cell.numberLabel.text = "15"
        } else if indexPath.row == 15 {
            cell.numberLabel.text = "16"
        } else if indexPath.row == 16 {
            cell.numberLabel.text = "17"
        } else if indexPath.row == 17 {
            cell.numberLabel.text = "18"
        } else if indexPath.row == 18 {
            cell.numberLabel.text = "19"
        } else if indexPath.row == 20 {
            cell.numberLabel.text = "21"
        } else if indexPath.row == 21 {
            cell.numberLabel.text = "22"
        } else if indexPath.row == 22 {
            cell.numberLabel.text = "23"
        } else if indexPath.row == 23 {
            cell.numberLabel.text = "24"
        } else if indexPath.row == 24 {
            cell.numberLabel.text = "25"
        } else if indexPath.row == 25 {
            cell.numberLabel.text = "26"
        } else if indexPath.row == 26 {
            cell.numberLabel.text = "27"
        } else if indexPath.row == 27 {
            cell.numberLabel.text = "28"
        } else if indexPath.row == 28 {
            cell.numberLabel.text = "29"
        } else if indexPath.row == 29 {
            cell.numberLabel.text = "30"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row].uid)
    }
}

extension LikeCountSortViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: " 検索地域のいいねランキングが\nこちらに表示されます。", attributes: attributes)
    }
}
