//
//  BlockTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//
import UIKit
import JGProgressHUD

class BlockTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    
    var userId = ""
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func blockButtonPressed(_ sender: Any) {
        
        saveBlock()
    }
    
    // MARK: - Fetch
    
    private func fetchUser() {
        guard userId != "" else { return }
        
        User.fetchUser(userId) { (user) in
            self.user = user
            self.setupUserInfo(user)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func saveBlock() {
        
        Block.saveBlock(toUserId: userId)
        hud.textLabel.text = "ブロックしました"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        navigationItem.title = "ブロック"
        profileImageView.layer.cornerRadius = 80 / 2
        blockButton.layer.cornerRadius = 15
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            blockButton.backgroundColor = UIColor(named: O_PINK)
            blockButton.setTitleColor(UIColor.white, for: .normal)
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            blockButton.backgroundColor = UIColor(named: O_GREEN)
            blockButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            blockButton.backgroundColor = UIColor.white
            blockButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
            blockButton.layer.borderColor = UIColor.systemGray3.cgColor
            blockButton.layer.borderWidth = 1
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            blockButton.backgroundColor = UIColor(named: O_DARK)
            blockButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func setupUserInfo(_ user: User) {
        
        nameLabel.text = user.username
        ageLabel.text = String(user.age)
        residenceLabel.text = user.residence
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl1), completed: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
