//
//  ReportTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class ReportTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var userId = ""
    private var user = User()
    private var currentUser = User()
    private var hud = JGProgressHUD(style: .dark)

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if reportLabel.text == "通報内容" {
            hud.textLabel.text = "通報内容を入力してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        saveReport()
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser() {
        guard userId != "" else { return }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.currentUser = user
        }
        
        User.fetchUser(userId) { (user) in
            self.user = user
            self.setupUserInfo(user, self.currentUser)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveReport() {
        
        let dict = [FROM: currentUser.uid!,
                    TO: user.uid!,
                    "fromEmail": currentUser.email!,
                    "toEmail": user.email!,
                    REPORT: reportLabel.text!,
                    GENDER: currentUser.gender as Any,
                    TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        COLLECTION_REPORT.document(User.currentUserId()).collection("reports").document().setData(dict) { (error) in
            if let error = error {
                print("Error save report: \(error.localizedDescription)")
            }
            updateUser(withValue: [REPORT: ""])
            self.hud.textLabel.text = "送信が完了しました"
            self.hud.show(in: self.view)
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.hud.dismiss(afterDelay: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func setupUI() {
        navigationItem.title = "通報"
        profileImageView.layer.cornerRadius = 80 / 2
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
    
    private func setupUserInfo(_ user: User, _ currentUser: User) {
        
        nameLabel.text = user.username
        ageLabel.text = String(user.age)
        residenceLabel.text = user.residence
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
        
        if currentUser.report == "" {
            reportLabel.text = "通報内容"
            inputLabel.isHidden = false
        } else {
            reportLabel.text = currentUser.report
            inputLabel.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
