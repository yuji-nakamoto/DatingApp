//
//  DidTypeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import NVActivityIndicatorView
import EmptyDataSet_Swift

class DidTypeTableViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var backView: UIView!
    
    private var typeArray = [Type]()
    private var users = [User]()
    private var interstitial: GADInterstitial!
    private var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupIndicator()
        fetchTypedUsers()
        updateUser(withValue: [NEWTYPE: false])
        
        setupBanner()
        interstitial = createAndLoadIntersitial()
//        testBanner()
//        interstitial = testIntersitial()
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

    // MARK: - Fetch
    
    private func fetchTypeUsers() {
        
        showLoadingIndicator()
        segmentControl.isEnabled = false
        typeArray.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypeUsers { (type) in
            if type.uid == "" {
                self.segmentControl.isEnabled = true
                self.hideLoadingIndicator()
                return
            }
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.typeArray.insert(type, at: 0)
                self.segmentControl.isEnabled = true
                self.hideLoadingIndicator()
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchTypedUsers() {
        
        showLoadingIndicator()
        segmentControl.isEnabled = false
        typeArray.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypedUsers { (type) in
            if type.uid == "" {
                self.segmentControl.isEnabled = true
                self.hideLoadingIndicator()
                return
            }
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.typeArray.insert(type, at: 0)
                self.segmentControl.isEnabled = true
                self.hideLoadingIndicator()
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
    
    private func setupIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 150, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
    }
    
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
        navigationItem.title = "タイプ"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
}

// MARK: - Table view

extension DidTypeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        cell.type = typeArray[indexPath.row]
        
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
                self.performSegue(withIdentifier: "DetailVC", sender: self.typeArray[indexPath.row].uid)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(logout)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            return
        }
        performSegue(withIdentifier: "DetailVC", sender: typeArray[indexPath.row].uid)
    }
}

extension DidTypeTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "タイプ履歴はありません", attributes: attributes)
    }
}
