//
//  SendPostTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SendPostTableViewController: UITableViewController, GADInterstitialDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
    
    private let userDefaults = UserDefaults.standard
    private var pleaceholderLbl = UILabel()
    private var user = User()
    private var match = Match()
    private var interstitial: GADInterstitial!
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        fetchUser()
        
//        interstitial = createAndLoadIntersitial()
        interstitial = testIntersitial()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupGenre()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        userDefaults.removeObject(forKey: LOVER)
        userDefaults.removeObject(forKey: FRIEND)
        userDefaults.removeObject(forKey: MAILFRIEND)
        userDefaults.removeObject(forKey: PLAY)
        userDefaults.removeObject(forKey: FREE)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if selectLabel.text == "選択してください" {
            hud.textLabel.text = "ジャンルを選択してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        if textView.text.count == 0 {
            hud.textLabel.text = "文字を入力してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        if textView.text.count > 30 {
            hud.textLabel.text = "30文字以下で入力してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        sendButton.isEnabled = false
        let day = Date()
        let oneDayLate = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        let dict = [UID: User.currentUserId(),
                    GENDER: user.gender!,
                    RESIDENCE: user.residence!,
                    CAPTION: textView.text!,
                    GENRE: selectLabel.text!,
                    ONEDAYLATE: oneDayLate,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Post.savePost(withValue: dict)
        
        userDefaults.removeObject(forKey: LOVER)
        userDefaults.removeObject(forKey: FRIEND)
        userDefaults.removeObject(forKey: MAILFRIEND)
        userDefaults.removeObject(forKey: PLAY)
        userDefaults.removeObject(forKey: FREE)
        UserDefaults.standard.set(true, forKey: REFRESH3)
        
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Error interstitial")
            }
        } else {
            hud.textLabel.text = "投稿しました"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.dismiss(afterDelay: 2.0)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
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
        dismiss(animated: true, completion: nil)
    }
    
    private func setupGenre() {
        
        if userDefaults.object(forKey: LOVER) != nil {
            selectLabel.text = "恋人募集"
        } else if userDefaults.object(forKey: FRIEND) != nil {
            selectLabel.text = "友達募集"
        } else if userDefaults.object(forKey: MAILFRIEND) != nil {
            selectLabel.text = "メル友募集"
        } else if userDefaults.object(forKey: PLAY) != nil {
            selectLabel.text = "遊びたい"
        } else if userDefaults.object(forKey: FREE) != nil {
            selectLabel.text = "ヒマしてる"
        }
    }
    
    private func setupTextView() {
        
        textView.delegate = self
        pleaceholderLbl.isHidden = false
        
        let pleaceholderX: CGFloat = self.view.frame.size.width / 75
        let pleaceholderY: CGFloat = -30
        let pleaceholderWidth: CGFloat = textView.bounds.width - pleaceholderX
        let pleaceholderHeight: CGFloat = textView.bounds.height
        let pleaceholderFontSize = self.view.frame.size.width / 25
        
        pleaceholderLbl.frame = CGRect(x: pleaceholderX, y: pleaceholderY, width: pleaceholderWidth, height: pleaceholderHeight)
        pleaceholderLbl.text = "30文字以内で入力してください"
        pleaceholderLbl.font = UIFont(name: "HelveticaNeue", size: pleaceholderFontSize)
        pleaceholderLbl.textColor = .systemGray4
        pleaceholderLbl.textAlignment = .left
        
        textView.addSubview(pleaceholderLbl)
    }
    
    private func setupUI() {
        sendButton.isEnabled = true
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
        navigationItem.title = "投稿内容"
    }
}

extension SendPostTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let spacing = CharacterSet.whitespacesAndNewlines
        
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            
            pleaceholderLbl.isHidden = true
        } else {
            pleaceholderLbl.isHidden = false
        }
        
        let reportNum = 30 - textView.text.count
        if reportNum < 0 {
            countLabel.text = "文字数制限です"
        } else {
            countLabel.text = String(reportNum)
        }
    }
}
