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
        setupBanner()
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
    
    private func hudError() {
        hud.show(in: self.view)
        hud.textLabel.text = "フリマポイントが足りません。"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
    
    private func hudSuccess() {
        hud.show(in: self.view)
        hud.textLabel.text = "アイテムと交換しました。"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
}

// MARK: - Table view

extension ShopTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
        
        if indexPath.row == 0 {
            cell.shopItem1()

        } else if indexPath.row == 1 {
            cell.shopItem2()
        } else if indexPath.row == 2 {
            cell.shopItem3()
        } else if indexPath.row == 3 {
            cell.shopItem4(self.user)
        } else if indexPath.row == 4 {
            cell.shopItem5(self.user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let alert: UIAlertController = UIAlertController(title: "おかわり", message: "1ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points == 0 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 1, ITEM1: self.user.item1 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 1 {
            
            let alert: UIAlertController = UIAlertController(title: "目立ちたがり屋", message: "1ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points == 0 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 1, ITEM2: self.user.item2 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 2 {
            
            let alert: UIAlertController = UIAlertController(title: "仕切り直し", message: "3ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 2 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 3, ITEM3: self.user.item3 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 3 {
            
            if user.item4 == 1 || user.usedItem4 == 1 {
                return
            }
            let alert: UIAlertController = UIAlertController(title: "開眼", message: "10ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 9 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 10, ITEM4: self.user.item4 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 3 {
            
            if user.item4 == 1 || user.usedItem4 == 1 {
                return
            }
            let alert: UIAlertController = UIAlertController(title: "開眼", message: "10ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 9 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 10, ITEM4: self.user.item4 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 4 {

            let alert: UIAlertController = UIAlertController(title: "割り込み", message: "1ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points == 0 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 1, ITEM5: self.user.item5 + 1])
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
