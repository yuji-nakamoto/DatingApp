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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    
    private var users = [User]()
    private var user = User()
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
//        setupBanner()
        testBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: toSearchVC()
        case 1: toLikeNationVC()
        case 2: break
        default: break
        }
    }
    
    @objc func refreshCollectionView(){
        fetchUsers(self.user)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.fetchUsers(self.user)
            self.tableView.reloadData()
        }
    }
    
    private func fetchUsers(_ user: User) {
        
        let residence = user.residenceSerch
        if residence == "こだわらない" {
            User.likeCountSortNationwide(user) { (users) in
                self.users = users
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        } else {
            User.likeCountSort(residence!, user) { (users) in
                self.users = users
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
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
        
        UserDefaults.standard.set(true, forKey: LANKBAR)
        navigationItem.title = "いいねランキング"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        refresh.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let toUserId = sender as! String
            messageVC.toUserId = toUserId
        }
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    private func toSearchVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toSearchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchCollectionViewController
        navigationController?.pushViewController(toSearchVC, animated: false)
    }
    
    private func toLikeNationVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toLikeNationVC = storyboard.instantiateViewController(withIdentifier: "LikeNationVC") as! LikeNationwideViewController
        navigationController?.pushViewController(toLikeNationVC, animated: false)
    }
}

// MARK: - Table view

extension LikeCountSortViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        cell.user = users[indexPath.row]
        cell.likeCountVC = self
        cell.likeCountUserCell(users[indexPath.row])
        if indexPath.row == 0 {
            cell.numberLabel.text = "1"
            cell.numberLabel.textColor = UIColor(named: O_GREEN)

        } else if indexPath.row == 1 {
            cell.numberLabel.text = "2"
            cell.numberLabel.textColor = .systemYellow
        } else if indexPath.row == 2 {
            cell.numberLabel.text = "3"
            cell.numberLabel.textColor = .systemPink
        } else if indexPath.row == 3 {
            cell.numberLabel.text = "4"
            cell.numberLabel.textColor = .systemBlue
        } else if indexPath.row == 4 {
            cell.numberLabel.text = "5"
            cell.numberLabel.textColor = .systemOrange
        } else if indexPath.row == 5 {
            cell.numberLabel.text = "6"
            cell.numberLabel.textColor = .systemTeal
        } else if indexPath.row == 6 {
            cell.numberLabel.text = "7"
            cell.numberLabel.textColor = .systemPurple
        } else if indexPath.row == 7 {
            cell.numberLabel.text = "8"
            cell.numberLabel.textColor = .systemGreen
        } else if indexPath.row == 8 {
            cell.numberLabel.text = "9"
            cell.numberLabel.textColor = UIColor(named: O_PINK)
        } else if indexPath.row == 9 {
            cell.numberLabel.text = "10"
            cell.numberLabel.textColor = .systemFill
        } else if indexPath.row == 10 {
            cell.numberLabel.text = "11"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 11 {
            cell.numberLabel.text = "12"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 12 {
            cell.numberLabel.text = "13"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 13 {
            cell.numberLabel.text = "14"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 14 {
            cell.numberLabel.text = "15"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 15 {
            cell.numberLabel.text = "16"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 16 {
            cell.numberLabel.text = "17"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 17 {
            cell.numberLabel.text = "18"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 18 {
            cell.numberLabel.text = "19"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 20 {
            cell.numberLabel.text = "21"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 21 {
            cell.numberLabel.text = "22"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 22 {
            cell.numberLabel.text = "23"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 23 {
            cell.numberLabel.text = "24"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 24 {
            cell.numberLabel.text = "25"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 25 {
            cell.numberLabel.text = "26"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 26 {
            cell.numberLabel.text = "27"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 27 {
            cell.numberLabel.text = "28"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 28 {
            cell.numberLabel.text = "29"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        } else if indexPath.row == 29 {
            cell.numberLabel.text = "30"
            cell.numberLabel.textColor = UIColor(named: O_BLACK)
        }
        
        return cell
    }
}

extension LikeCountSortViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: " 検索地域のいいねランキングが\nこちらに表示されます。", attributes: attributes)
    }
}
