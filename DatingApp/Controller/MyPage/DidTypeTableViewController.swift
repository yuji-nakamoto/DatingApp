//
//  DidTypeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class DidTypeTableViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var typeUsers = [Type]()
    private var users = [User]()
    private var interstitial: GADInterstitial!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchTypedUsers()
        
//        setupBanner()
//        interstitial = createAndLoadIntersitial()
        testBanner()
        interstitial = testIntersitial()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchTypedUsers()
        case 1: fetchTypeUsers()
        default: break
        }
    }

    // MARK: - Fetch isLike
    
    private func fetchTypeUsers() {
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        typeUsers.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypeUsers { (type) in
            if type.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.typeUsers.insert(type, at: 0)
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Fetch liekd
    
    private func fetchTypedUsers() {
        
        indicator.startAnimating()
        segmentControl.isEnabled = false
        typeUsers.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypedUsers { (type) in
            if type.uid == "" {
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                return
            }
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.typeUsers.insert(type, at: 0)
                self.segmentControl.isEnabled = true
                self.indicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch user
    
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
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    // MARK: - Helpers
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-4750883229624981/4674347886")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    private func testIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
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
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        navigationItem.title = "タイプ"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        backView.alpha = 0.85

        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            navigationItem.leftBarButtonItem?.tintColor = UIColor(named: O_BLACK)
            backView.backgroundColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_DARK)
        }
    }
}

// MARK: - Table view data source


extension DidTypeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return typeUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let type = typeUsers[indexPath.row]
        cell.type = type
        
        if segmentControl.selectedSegmentIndex == 0 && UserDefaults.standard.object(forKey: FEMALE) == nil {
            cell.configureCell2(users[indexPath.row])
            return cell
        }
        cell.configureCell3(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if segmentControl.selectedSegmentIndex == 0 && UserDefaults.standard.object(forKey: FEMALE) == nil {
            let alert: UIAlertController = UIAlertController(title: "広告の表示" , message: "プロフィールに移動すると広告が表示されます", preferredStyle: .actionSheet)
            let logout: UIAlertAction = UIAlertAction(title: "移動する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.interstitial.isReady {
                    self.interstitial.present(fromRootViewController: self)
                } else {
                    print("Error interstitial")
                }
                self.performSegue(withIdentifier: "DetailVC", sender: self.typeUsers[indexPath.row].uid)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(logout)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            return
        }
        performSegue(withIdentifier: "DetailVC", sender: typeUsers[indexPath.row].uid)
    }
}

extension DidTypeTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 17, weight: .regular)]
        return NSAttributedString(string: "タイプ履歴が、\nこちらに表示されます。", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "気になった方にタイプを送り、\nアプローチをしてみましょう。")
    }
}
