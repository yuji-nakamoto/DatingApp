//
//  ShopTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/25.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import JGProgressHUD

class ShopTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUserAddSnapshotListener { (user) in
            self.user = user
            self.pointLabel.text = String(self.user.points)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        navigationItem.title = "ショップ"
        tableView.tableFooterView = UIView()
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            navigationItem.leftBarButtonItem?.tintColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }
    
    private func setupBanner() {
            
            // test adUnitID
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
    //        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
}

// MARK: - Table view

extension ShopTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
        
        cell.shopItem1()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let alert: UIAlertController = UIAlertController(title: "メッセージ送信できる券", message: "1ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points == 0 {
                    self.hud.textLabel.text = "フリマポイントが足りません。"
                    self.hud.show(in: self.view)
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    self.hud.textLabel.text = "アイテムと交換しました。"
                    self.hud.show(in: self.view)
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.dismiss(afterDelay: 2.0)
                    updateUser(withValue: [POINTS: self.user.points - 1, ITEM1: self.user.item1 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
}
