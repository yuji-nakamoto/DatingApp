//
//  CommunityUsersViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/18.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class CommunityUsersViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var users = [User]()
    private var user = User()
    var community = Community()
    var communityId = ""
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        fetchCurrentUser()
        fetchCommunity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func communityButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "コミュニティに参加しますか？", preferredStyle: .actionSheet)
        let participation: UIAlertAction = UIAlertAction(title: "参加する", style: UIAlertAction.Style.default) { (alert) in
            self.setupParticipation()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(participation)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func withdrawButtonPressed(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "コミュニティを退会しますか？", preferredStyle: .actionSheet)
        let withdraw: UIAlertAction = UIAlertAction(title: "退会する", style: UIAlertAction.Style.default) { (alert) in
            self.setupWithdraw()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(withdraw)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            
            if self.user.community1 == self.communityId {
                self.setupCommunityButton()
            } else if self.user.community2 == self.communityId {
                self.setupCommunityButton()
            } else if self.user.community3 == self.communityId {
                self.setupCommunityButton()
            }
            self.fetchUsers(self.user)
        }
    }
    
    private func fetchUsers(_ user: User) {
        
        indicator.startAnimating()
        User.fetchCommunityUsers(communityId: self.communityId) { (user) in
            self.users = user
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchCommunity() {
        guard communityId != "" else { return }
        Community.fetchCommunity(communityId: self.communityId) { (community) in
            self.community = community
            self.navigationItem.title = "\(self.community.title ?? "")"
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupParticipation() {
        
        if user.community1 == "" {
            updateUser(withValue: [COMMUNITY1: self.communityId])
        } else if user.community2 == "" {
            updateUser(withValue: [COMMUNITY2: self.communityId])
        } else if user.community3 == "" {
            updateUser(withValue: [COMMUNITY3: self.communityId])
        } else {
            hud.textLabel.text = "これ以上、参加できません"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        Community.updateCommunity(communityId: self.communityId,
                                  value1: [NUMBER: self.community.number + 1],
                                  value2: [User.currentUserId(): true])
        fetchCurrentUser()
        fetchCommunity()
        communityButton.setTitle("参加中", for: .normal)
        communityButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        communityButton.backgroundColor = UIColor.systemGray2
        communityButton.isEnabled = false
        withdrawButton.isHidden = false
        widthConstraint.constant = 150
    }
    
    private func setupWithdraw() {
        
        Community.updateCommunity(communityId: self.communityId,
                                  value1: [NUMBER: self.community.number - 1],
                                  value2: [User.currentUserId(): FieldValue.delete()])
        
        if user.community1 == self.communityId {
            updateUser(withValue: [COMMUNITY1: ""])
        } else if user.community2 == self.communityId {
            updateUser(withValue: [COMMUNITY2: ""])
        } else if user.community3 == self.communityId {
            updateUser(withValue: [COMMUNITY3: ""])
        }
        
        fetchCurrentUser()
        fetchCommunity()
        communityButton.setTitle("コミュニティに参加する", for: .normal)
        communityButton.setTitleColor(UIColor.white, for: .normal)
        communityButton.backgroundColor = UIColor(named: O_GREEN)
        communityButton.isEnabled = true
        withdrawButton.isHidden = true
        widthConstraint.constant = 300
    }
    
    private func setupCommunityButton() {
        
        withdrawButton.isHidden = false
        communityButton.setTitle("参加中", for: .normal)
        communityButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        communityButton.backgroundColor = UIColor.systemGray2
        communityButton.isEnabled = false
        widthConstraint.constant = 150
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.panGestureRecognizer.translation(in: scrollView).y < -100 {
            navigationController?.navigationBar.isHidden = false
        } else {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
    }
    
    private func setup() {
        
        withdrawButton.isHidden = true
        communityButton.layer.cornerRadius = 44 / 2
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Collection view

extension CommunityUsersViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 414, height: 300)
        }
        return CGSize(width: 180, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CommunityUsersCollectionViewCell
            cell2.configureCell(self.community)
            
            return cell2
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCommunityCell(users[indexPath.row - 1])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1].uid)
        }
    }
}
