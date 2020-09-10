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
    @IBOutlet weak var usedLabel4: UILabel!
    @IBOutlet weak var usedLabel5: UILabel!
    @IBOutlet weak var usedLabel6: UILabel!
    @IBOutlet weak var usedLabel7: UILabel!
    
    @IBOutlet weak var usedView: UIView!
    @IBOutlet weak var barViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var isReadSwitch: UISwitch!
    @IBOutlet weak var isReadLabel: UILabel!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
        
//        setupBanner()
        testBanner()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: VIEW_ON) != nil {
            UIView.animate(withDuration: 0.5) {
                self.usedView.isHidden = !self.usedView.isHidden
                self.barViewTopConstraint.constant = 275
                UserDefaults.standard.removeObject(forKey: VIEW_ON)
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.usedView.isHidden = !self.usedView.isHidden
                self.barViewTopConstraint.constant = 0
                UserDefaults.standard.set(true, forKey: VIEW_ON)
            }
        }
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUserAddSnapshotListener { (user) in
            self.user = user
            self.tableView.reloadData()
            self.usedItems(self.user)
            self.setupIsRead(self.user)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func isReadSwtched(_ sender: UISwitch) {
        
        if sender.isOn {
            generator.notificationOccurred(.success)
            UserDefaults.standard.set(true, forKey: ISREAD_ON)
            isReadLabel.text = "既読表示をする"
        } else {
            generator.notificationOccurred(.success)
            UserDefaults.standard.removeObject(forKey: ISREAD_ON)
            isReadLabel.text = "既読表示をしない"
        }
    }
    
    // MARK: - Helpers
    
    private func usedItems(_ user: User) {
        
        if self.user.usedItem1 > 0 {
            self.usedLabel1.text = "\(user.usedItem1!)枚使用可"
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
        
        if self.user.usedItem5 > 0 {
            self.usedLabel4.text = "\(user.usedItem5!)枚使用中"
            self.usedLabel4.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel4.text = "未使用"
            self.usedLabel4.textColor = .systemGray
        }
        
        if self.user.usedItem6 > 0 {
            self.usedLabel5.text = "使用中"
            self.usedLabel5.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel5.text = "未使用"
            self.usedLabel5.textColor = .systemGray
        }
        
        if self.user.usedItem7 > 0 {
            self.usedLabel6.text = "使用中"
            self.usedLabel6.textColor = UIColor(named: O_GREEN)
        } else {
            self.usedLabel6.text = "未使用"
            self.usedLabel6.textColor = .systemGray
        }
        
        if self.user.usedItem8 > 0 {
            self.usedLabel7.isHidden = true
        } else {
            self.usedLabel7.isHidden = false
            self.usedLabel7.text = "未使用"
            self.usedLabel7.textColor = .systemGray
        }
        
        self.tableView.reloadData()
    }
        
    private func setupIsRead(_ user: User) {
        
        if self.user.usedItem8 == 1 {
            self.isReadSwitch.isHidden = false
            self.isReadLabel.text = "既読表示をする"
            
            if UserDefaults.standard.object(forKey: ISREAD_ON) != nil {
                self.isReadSwitch.isOn = true
                self.isReadLabel.text = "既読表示をする"
            } else {
                self.isReadSwitch.isOn = false
                self.isReadLabel.text = "既読表示をしない"
            }
            
        } else {
            self.isReadSwitch.isHidden = true
            self.isReadLabel.text = "透視"
        }
    }
    
    private func setupUI() {
        navigationItem.title = "所持アイテム"
        tableView.tableFooterView = UIView()
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
    
    private func hudSuccess() {
        hud.textLabel.text = "アイテムを使用しました"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
    
    private func hudSuccess2() {
        hud.textLabel.text = "アイテムを使用しました。効果が反映されました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
}

// MARK: - Table view

extension ItemTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
        
        if indexPath.row == 0 {
            cell.possessionItem1(self.user)
        } else if indexPath.row == 1 {
            cell.possessionItem2(self.user)
        } else if indexPath.row == 2 {
            cell.possessionItem3(self.user)
        } else if indexPath.row == 3 {
            cell.possessionItem4(self.user)
        } else if indexPath.row == 4 {
            cell.possessionItem5(self.user)
        } else if indexPath.row == 5 {
            cell.possessionItem6(self.user)
        } else if indexPath.row == 6 {
            cell.possessionItem7(self.user)
        } else if indexPath.row == 7 {
            cell.possessionItem8(self.user)
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
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
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
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 2 {
            
            if user.item3 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "割り込み", message: "アイテムを使用します。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                updateUser(withValue: [ITEM3: self.user.item3 - 1, USEDITEM3: self.user.usedItem3 + 1])
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 4 {
            
            if user.item5 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "仕切り直し", message: "アイテムを使用します。効果は即座に反映されます。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                updateUser(withValue: [ITEM5: self.user.item5 - 1, USEDITEM5: self.user.usedItem5 + 1])
                self.hud.show(in: self.view)
                
                COLLECTION_SWIPE.document(User.currentUserId()).delete { (error) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        updateUser(withValue: [USEDITEM5: self.user.usedItem5 - 1])
                        self.hudSuccess2()
                    }
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)

        } else if indexPath.row == 5 {
            
            if user.item6 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "開眼", message: "アイテムを使用します。効果は即座に反映されます。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                self.hud.show(in: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    updateUser(withValue: [ITEM6: self.user.item6 - 1, USEDITEM6: self.user.usedItem6 + 1])
                    self.hudSuccess2()
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 6 {
            
            if user.item7 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "フリマップ", message: "アイテムを使用します。効果は即座に反映されます。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                self.hud.show(in: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    updateUser(withValue: [ITEM7: self.user.item7 - 1, USEDITEM7: self.user.usedItem7 + 1])
                    self.hudSuccess2()
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 7 {
            
            if user.item8 == 0 { return }
            let alert: UIAlertController = UIAlertController(title: "透視", message: "アイテムを使用します。効果は即座に反映されます。使用しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                self.hud.show(in: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    updateUser(withValue: [ITEM8: self.user.item8 - 1, USEDITEM8: self.user.usedItem8 + 1])
                    UserDefaults.standard.set(true, forKey: ISREAD_ON)
                    self.hudSuccess2()
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
        
    }
}
