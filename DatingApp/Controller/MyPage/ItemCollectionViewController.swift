//
//  ItemCollectionViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import JGProgressHUD

class ItemCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        testBanner()
        
        fetchUser()
        navigationItem.title = "所持アイテム"
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        
        User.fetchUserAddSnapshotListener { (user) in
            self.user = user
            self.tableView.reloadData()
            self.collectionView.reloadData()
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
    
    private func hudSuccess() {
        hud.textLabel.text = "アイテムを使用しました"
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1)
    }
}

// MARK: - Table view

extension ItemCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemTableViewCell
        cell.itemVC = self
        cell.usedItems(self.user)
        cell.setupIsRead(self.user)
        return cell
    }
}

// MARK: - Collection view

extension ItemCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ItemCollectionViewCell
        
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false
        
        cell.itemCollectionVC = self
        
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
        } else if indexPath.row == 8 {
            cell.possessionItem9(self.user)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let alert = UIAlertController(title: "おかわり", message: "マッチしていなくてもメッセージを追加で送信できます", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            
            alert.addAction(verification)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 1 {
            
            let alert = UIAlertController(title: "目立ちたがり屋", message: "あなたのプロフィールが上位に表示されるようになります。効果は重複します", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            let exchange = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                
                updateUser(withValue: [ITEM2: self.user.item2 - 1,
                                       USEDITEM2: self.user.usedItem2 + 1])
                self.hudSuccess()
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            if user.item2 == 0 {
                alert.addAction(verification)
                self.present(alert,animated: true,completion: nil)
            } else {
                alert.addAction(exchange)
                alert.addAction(cancel)
                self.present(alert,animated: true,completion: nil)
            }
            
        } else if indexPath.row == 2 {
            
            let alert = UIAlertController(title: "割り込み", message: "あなたが送ったメッセージが上位に表示されるようになります。効果は重複します", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            let exchange = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                updateUser(withValue: [ITEM3: self.user.item3 - 1,
                                       USEDITEM3: self.user.usedItem3 + 1])
                self.hudSuccess()
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            if user.item3 == 0 {
                alert.addAction(verification)
                self.present(alert,animated: true,completion: nil)
            } else {
                alert.addAction(exchange)
                alert.addAction(cancel)
                self.present(alert,animated: true,completion: nil)
            }
            
        } else if indexPath.row == 3 {
            
            let alert: UIAlertController = UIAlertController(title: "献上", message: "気になるお相手にポイントをプレゼントできます。あなたには運営からいいね！をプレゼント！", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "確認", style: .cancel)
            
            alert.addAction(cancel)
            self.present(alert,animated: true,completion: nil)
            
        } else if indexPath.row == 4 {
            
            let alert: UIAlertController = UIAlertController(title: "仕切り直し", message: "スワイプでいなくなったユーザーが復活します", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { (alert) in
                updateUser(withValue: [ITEM5: self.user.item5 - 1,
                                       USEDITEM5: self.user.usedItem5 + 1])
                self.hud.textLabel.text = "アイテムを使用しました。効果が反映されました"
                self.hud.show(in: self.view)
                
                COLLECTION_SWIPE.document(User.currentUserId()).delete { [self] (error) in
                    updateUser(withValue: [USEDITEM5: self.user.usedItem5 - 1])
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.dismiss(afterDelay: 1.5)
                }
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            if user.item5 == 0 {
                alert.addAction(verification)
                self.present(alert,animated: true,completion: nil)
            } else {
                alert.addAction(exchange)
                alert.addAction(cancel)
                self.present(alert,animated: true,completion: nil)
            }
            
        } else if indexPath.row == 5 {
            
            let alert: UIAlertController = UIAlertController(title: "開眼", message: "あなたのプロフィールに訪れた人数を確認できます。効果は永続します", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                hud.textLabel.text = "アイテムを使用しました。効果が反映されました"
                hud.show(in: self.view)
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.dismiss(afterDelay: 1.5)
                updateUser(withValue: [ITEM6: self.user.item6 - 1,
                                       USEDITEM6: self.user.usedItem6 + 1,
                                       MKAIGAN: true])
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            if user.item6 == 0 {
                alert.addAction(verification)
                self.present(alert,animated: true,completion: nil)
            } else {
                alert.addAction(exchange)
                alert.addAction(cancel)
                self.present(alert,animated: true,completion: nil)
            }
            
        } else if indexPath.row == 6 {
            
            let alert: UIAlertController = UIAlertController(title: "フリマップ", message: "お相手との距離表示が可能になります。効果は永続します", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                hud.textLabel.text = "アイテムを使用しました。効果が反映されました"
                hud.show(in: self.view)
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.dismiss(afterDelay: 1.5)
                updateUser(withValue: [ITEM7: self.user.item7 - 1,
                                       USEDITEM7: self.user.usedItem7 + 1,
                                       MFURIMAP: true])
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            if user.item7 == 0 {
                alert.addAction(verification)
                self.present(alert,animated: true,completion: nil)
            } else {
                alert.addAction(exchange)
                alert.addAction(cancel)
                self.present(alert,animated: true,completion: nil)
            }
            
        } else if indexPath.row == 7 {
            
            let alert: UIAlertController = UIAlertController(title: "透視", message: "メッセージの既読表示が可能になります。効果は永続します", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
            let exchange: UIAlertAction = UIAlertAction(title: "使用する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                hud.textLabel.text = "アイテムを使用しました。効果が反映されました"
                hud.show(in: self.view)
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.dismiss(afterDelay: 1.5)
                updateUser(withValue: [ITEM8: self.user.item8 - 1,
                                       USEDITEM8: self.user.usedItem8 + 1,
                                       MTOSHI: true])
                UserDefaults.standard.set(true, forKey: ISREAD_ON)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            if user.item8 == 0 {
                alert.addAction(verification)
                self.present(alert,animated: true,completion: nil)
            } else {
                alert.addAction(exchange)
                alert.addAction(cancel)
                self.present(alert,animated: true,completion: nil)
            }
            
        } else if indexPath.row == 8 {
            
            let alert: UIAlertController = UIAlertController(title: "お気に入り", message: "気になるお相手をお気に入り登録できます", preferredStyle: .alert)
            let verification = UIAlertAction(title: "確認", style: .cancel)
                      
            alert.addAction(verification)
            self.present(alert,animated: true,completion: nil)
        }
    }
}
