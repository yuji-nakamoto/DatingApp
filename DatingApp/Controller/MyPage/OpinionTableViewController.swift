//
//  OpinionTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class OpinionTableViewController: UITableViewController {
    
    // MARK: - Properties
    
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
        
        if opinionLabel.text == "ご意見・ご要望・改善等" {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "内容を入力してください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        saveOpinion()
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
    
    private func saveOpinion() {
        
        let dict = [FROM: currentUser.uid!,
                     GENDER: currentUser.gender as Any,
                     USERNAME: currentUser.username as Any,
                     OPINION: opinionLabel.text!,
                     TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_OPINION.document(User.currentUserId()).collection("oinions").document().setData(dict)
        
        updateUser(withValue: [OPINION: ""])
        hud.textLabel.text = "送信が完了しました。"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        navigationItem.title = "ご意見・ご要望・改善等"
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
