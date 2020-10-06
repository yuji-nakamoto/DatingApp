//
//  FavoriteTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/04.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class FavoriteTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var favoArray = [Favorite]()
    private var users = [User]()
    private var user = User()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
//        testBanner()
        
        setupUI()
        if UserDefaults.standard.object(forKey: REFRESH2) == nil {
            fetchFavoriteUsers()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: REFRESH2) != nil {
            fetchFavoriteUsers()
            UserDefaults.standard.removeObject(forKey: REFRESH2)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
    // MARK: - Fetch
    
    private func fetchFavoriteUsers() {
     
        indicator.startAnimating()
        favoArray.removeAll()
        users.removeAll()
        
        Favorite.fetchFavoriteUsers { (favorite) in
            if favorite.uid == "" {
                self.indicator.stopAnimating()
                self.tableView.reloadData()
                return
            }
            guard let uid = favorite.uid else { return }
            self.fetchUser(uid: uid) {
                self.favoArray.insert(favorite, at: 0)
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    // MARK: - Helpers
    
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
        
        navigationItem.title = "お気に入り"
        tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
}

// MARK: - Table view data source

extension FavoriteTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoriteTableViewCell
        
        cell.favoriteVC = self
        cell.user = users[indexPath.row]
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: favoArray[indexPath.row].uid)
    }
}

extension FavoriteTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: "お気に入り登録したお相手はいません", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "ショップでアイテム交換を行い、気になったお相手を登録しよう")
    }
}
