//
//  DidTypeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DidTypeTableViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var topBannerView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var types = [Type]()
    private var users = [User]()
    private var interstitial: GADInterstitial!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBanner()
        setupUI()
        fetchTypedUsers()
        interstitial = createAndLoadIntersitial()
        UIApplication.shared.applicationIconBadgeNumber = 0
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
        
        types.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypeUsers { (type) in
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.types.append(type)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Fetch liekd
    
    private func fetchTypedUsers() {
        
        types.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypedUser { (type) in
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.types.append(type)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch user
    
    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
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
    
    private func createAndLoadIntersitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadIntersitial()
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }

}

// MARK: - Table view data source


extension DidTypeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let type = types[indexPath.row]
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
                self.performSegue(withIdentifier: "DetailVC", sender: self.types[indexPath.row].uid)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(logout)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            return
        }
        performSegue(withIdentifier: "DetailVC", sender: types[indexPath.row].uid)
    }
}
