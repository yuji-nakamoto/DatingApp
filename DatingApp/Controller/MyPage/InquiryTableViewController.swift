//
//  InquiryTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class InquiryTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var inquiryLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var inputLabel2: UILabel!
    
    private var currentUser = User()
    public var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrentUser()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if inquiryLabel.text == "お問い合わせ内容" && opinionLabel.text == "ご意見・ご要望・改善等" {
            hud.textLabel.text = "どちらかの内容を入力してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        saveInquiry()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.setupUserInfo(self.currentUser)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveInquiry() {
        
        let dict = [FROM: currentUser.uid!,
                    GENDER: currentUser.gender as Any,
                    USERNAME: currentUser.username as Any,
                    EMAIL: currentUser.email!,
                    INQUIRY: inquiryLabel.text!,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        let dict2 = [FROM: currentUser.uid!,
                     GENDER: currentUser.gender as Any,
                     USERNAME: currentUser.username as Any,
                     EMAIL: currentUser.email!,
                     OPINION: opinionLabel.text!,
                     TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        if inquiryLabel.text != "お問い合わせ内容" {
            COLLECTION_INQUIRY.document(User.currentUserId()).collection("inquirys").document().setData(dict)
        }
        
        if opinionLabel.text != "ご意見・ご要望・改善等" {
            COLLECTION_OPINION.document(User.currentUserId()).collection("oinions").document().setData(dict2)
        }
        
        updateUser(withValue: [INQUIRY: "", OPINION: ""])
        hud.textLabel.text = "送信が完了しました"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        navigationItem.title = "お問い合わせ・ご意見等"
        sendButton.layer.cornerRadius = 15
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            sendButton.backgroundColor = UIColor(named: O_PINK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            sendButton.backgroundColor = UIColor(named: O_GREEN)
            sendButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            sendButton.backgroundColor = UIColor(named: O_GREEN)
            sendButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            sendButton.backgroundColor = UIColor(named: O_DARK)
            sendButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func setupUserInfo(_ currentUser: User) {
        
        if currentUser.inquiry == "" {
            inquiryLabel.text = "お問い合わせ内容"
            inputLabel.isHidden = false
        } else {
            inquiryLabel.text = currentUser.inquiry
            inputLabel.isHidden = true
        }
        
        if currentUser.opinion == "" {
            opinionLabel.text = "ご意見・ご要望・改善等"
            inputLabel2.isHidden = false
        } else {
            opinionLabel.text = currentUser.opinion
            inputLabel2.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
