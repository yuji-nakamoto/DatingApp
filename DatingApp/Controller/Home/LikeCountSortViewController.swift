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
        setupBanner()
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

        }
        
        return cell
    }
}

extension LikeCountSortViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        return NSAttributedString(string: " 検索地域のいいねランキングが\nこちらに表示されます。", attributes: attributes)
    }
}
