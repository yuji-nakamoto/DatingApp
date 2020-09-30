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
import GoogleMobileAds
import Firebase

class ShopTableViewController: UIViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    private var interstitial: GADInterstitial!
    private var timer = Timer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
        showHintView()
        resetPointButton()
        
//          setupBanner()
//          interstitial = createAndLoadIntersitial()
        testBanner()
        interstitial = testIntersitial()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        removeEffectView()
    }
    
    @IBAction func pointButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "CM視聴で1ポイント獲得できます\n視聴しますか？", preferredStyle: .alert)
        let showAds: UIAlertAction = UIAlertAction(title: "視聴する", style: UIAlertAction.Style.default) { (alert) in
            
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (alert) in
        }
        alert.addAction(showAds)
        alert.addAction(cancel)
        self.present(alert,animated: true,completion: nil)
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
    
    private func showHintView() {
        
        if UserDefaults.standard.object(forKey: HINT_END2) == nil {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.hintView.alpha = 1
                    self.backView.alpha = 0.9
                }, completion: nil)
            }
        }
    }
    
    private func removeEffectView() {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.hintView.alpha = 0
            self.backView.alpha = 0
            UserDefaults.standard.set(true, forKey: HINT_END2)
        })
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
        let day = Date()
        let pointHalfLate = Calendar.current.date(byAdding: .hour, value: 12, to: day)!
        
        updateUser(withValue: [POINTS: self.user.points + 1, POINTHALFLATE: pointHalfLate])
        UserDefaults.standard.set(true, forKey: POINTBUTTON)
        
        hud.show(in: self.view)
        hud.textLabel.text = "ポイント追加しました\n12時間後にCMを視聴できます"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 3.0)
        
        self.pointButton.isEnabled = false
    }
    
    private func resetPointButton() {
        
        if UserDefaults.standard.object(forKey: POINTBUTTON) != nil {
            self.pointButton.isEnabled = false
        }
        
        User.fetchUserAddSnapshotListener { (user) in
            self.user = user
            
            let now = Timestamp()
            let nowDate = now.dateValue()
            let pointHalfLate = user.pointHalfLate.dateValue()
            
            if nowDate >= pointHalfLate {
                UserDefaults.standard.removeObject(forKey: POINTBUTTON)
                self.pointButton.isEnabled = true
            }
        }
    }
    
    private func setupUI() {
        
        navigationItem.title = "ショップ"
        pointButton.layer.cornerRadius = 23 / 2
        tableView.tableFooterView = UIView()
        hintView.alpha = 0
        backView.alpha = 0
        hintView.layer.cornerRadius = 15
        closeButton.layer.cornerRadius = 40 / 2
        descriptionLabel.text = "ログインボーナス等で獲得したポイントをアイテムと交換しよう！\n\nアイテムを活用するとマッチしやすくなるかも！？"
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
    
    private func hudError() {
        hud.show(in: self.view)
        hud.textLabel.text = "フリマポイントが足りません"
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
    
    private func hudSuccess() {
        hud.show(in: self.view)
        hud.textLabel.text = "アイテムと交換しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
}

// MARK: - Table view

extension ShopTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
            cell.shopItem4()
        } else if indexPath.row == 4 {
            cell.shopItem5()
        } else if indexPath.row == 5 {
            cell.shopItem6(self.user)
        } else if indexPath.row == 6 {
            cell.shopItem7(self.user)
        } else if indexPath.row == 7 {
            cell.shopItem8(self.user)
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
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
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
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 2 {
            
            let alert: UIAlertController = UIAlertController(title: "割り込み", message: "1ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points == 0 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 1, ITEM3: self.user.item3 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 3 {
            
            let alert: UIAlertController = UIAlertController(title: "献上", message: "1ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points == 0 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 1, ITEM4: self.user.item4 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 4 {
            
            let alert: UIAlertController = UIAlertController(title: "仕切り直し", message: "3ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 2 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 3, ITEM5: self.user.item5 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 5 {
            
            if user.item6 == 1 || user.usedItem6 == 1 {
                return
            }
            let alert: UIAlertController = UIAlertController(title: "開眼", message: "10ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 9 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 10, ITEM6: self.user.item6 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 6 {
            
            if user.item7 == 1 || user.usedItem7 == 1 {
                return
            }
            let alert: UIAlertController = UIAlertController(title: "フリマップ", message: "15ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 14 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 15, ITEM7: self.user.item7 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 7 {
            
            if user.item8 == 1 || user.usedItem8 == 1 {
                return
            }
            let alert: UIAlertController = UIAlertController(title: "透視", message: "15ポイントで交換できます。交換しますか？", preferredStyle: .alert)
            let exchange: UIAlertAction = UIAlertAction(title: "交換する", style: UIAlertAction.Style.default) { (alert) in
                
                if self.user.points <= 14 {
                    self.hudError()
                } else {
                    self.hudSuccess()
                    updateUser(withValue: [POINTS: self.user.points - 15, ITEM8: self.user.item8 + 1])
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(exchange)
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
        }
    }
}
