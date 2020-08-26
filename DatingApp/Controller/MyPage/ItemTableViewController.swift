//
//  ItemTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/25.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import JGProgressHUD

class ItemTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var usedLabel1: UILabel!
    @IBOutlet weak var usedLabel2: UILabel!
    @IBOutlet weak var usedLabel3: UILabel!
    
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
            self.usedItems(self.user)
        }
    }
    
    // MARK: - Helpers
    
    private func usedItems(_ user: User) {
        
        if self.user.usedItem1 > 0 {
            self.usedLabel1.text = "\(user.usedItem1!)枚使用中"
            self.usedLabel1.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel1.text = "未使用"
            self.usedLabel1.textColor = .systemGray
        }
        
        if self.user.usedItem2 > 0 {
            self.usedLabel2.text = "\(user.usedItem2!)枚使用中"
            self.usedLabel2.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel2.text = "未使用"
            self.usedLabel2.textColor = .systemGray
        }
        
        if self.user.usedItem3 > 0 {
            self.usedLabel3.text = "\(user.usedItem3!)枚使用中"
            self.usedLabel3.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel3.text = "未使用"
            self.usedLabel3.textColor = .systemGray
        }
        
        self.tableView.reloadData()
    }
    
    private func setupUI() {
        
        navigationItem.title = "所持アイテム"
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
    
    private func hudSuccess() {
        hud.textLabel.text = "アイテムを使用しました。"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
}

// MARK: - Table view

extension ItemTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
        
        if indexPath.row == 0 {
            cell.possessionItem1(self.user)
        } else if indexPath.row == 1 {
            cell.possessionItem2(self.user)
        } else if indexPath.row == 2 {
            cell.possessionItem3(self.user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if user.item1 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "おかわり", message: "アイテムを使用します。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                self.hudSuccess()
                updateUser(withValue: [ITEM1: self.user.item1 - 1, USEDITEM1: self.user.usedItem1 + 1])
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 1 {
            
            if user.item2 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "目立ちたがり屋", message: "アイテムを使用します。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                self.hudSuccess()
                updateUser(withValue: [ITEM2: self.user.item2 - 1, USEDITEM2: self.user.usedItem2 + 1])
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
            }
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 2 {
            
            if user.item3 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "仕切り直し", message: "アイテムを使用します。効果は即座に反映されます。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                updateUser(withValue: [ITEM3: self.user.item3 - 1, USEDITEM3: self.user.usedItem3 + 1])
                self.hud.show(in: self.view)
                
                COLLECTION_SWIPE.document(User.currentUserId()).delete { (error) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        updateUser(withValue: [USEDITEM3: self.user.usedItem3 - 1])
                        self.hud.textLabel.text = "アイテムを使用しました。効果が反映されました。"
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.dismiss(afterDelay: 2.0)
                    }
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
