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
import GoogleMobileAds

class CommunityUsersViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var withdrawButton1: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var withdrawButton2: UIButton!
    @IBOutlet weak var backButton1: UIButton!
    @IBOutlet weak var tweetButton1: UIButton!
    @IBOutlet weak var tweetButton2: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var users = [User]()
    private var user = User()
    var community = Community()
    var communityId = ""
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupBanner()
        testBanner()
        
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
    
    @IBAction func tweetButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "TweetVC", sender: communityId)
    }
    
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
            self.tableView.reloadData()
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
            self.titleLabel.text = "\(self.community.title ?? "")"
            self.tableView.reloadData()
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
    
    private func setupParticipation() {
        
        if user.community1 == "" {
            updateUser(withValue: [COMMUNITY1: self.communityId, MCOMMUNITYCOUNT: self.user.mCommunityCount + 1])
        } else if user.community2 == "" {
            updateUser(withValue: [COMMUNITY2: self.communityId, MCOMMUNITYCOUNT: self.user.mCommunityCount + 1])
        } else if user.community3 == "" {
            updateUser(withValue: [COMMUNITY3: self.communityId, MCOMMUNITYCOUNT: self.user.mCommunityCount + 1])
        } else {
            hud.textLabel.text = "これ以上、参加できません"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        if user.gender == "男性" {
            Community.updateCommunity(communityId: self.communityId,
                                      value1: [ALL_NUMBER: self.community.allNumber + 1,
                                               MALE_NUMBER: self.community.maleNumber + 1 ],
                                      value2: [User.currentUserId(): true])
        } else {
            Community.updateCommunity(communityId: self.communityId,
                                      value1: [ALL_NUMBER: self.community.allNumber + 1,
                                               FEMALE_NUMBER: self.community.femaleNumber + 1 ],
                                      value2: [User.currentUserId(): true])
        }
        
        fetchCurrentUser()
        fetchCommunity()
        setupParticipationButton()
    }
    
    private func setupWithdraw() {
        
        if user.gender == "男性" {
            Community.updateCommunity(communityId: self.communityId,
                                      value1: [ALL_NUMBER: self.community.allNumber - 1,
                                               MALE_NUMBER: self.community.maleNumber - 1],
                                      value2: [User.currentUserId(): FieldValue.delete()])
        } else {
            Community.updateCommunity(communityId: self.communityId,
                                      value1: [ALL_NUMBER: self.community.allNumber - 1,
                                               FEMALE_NUMBER: self.community.femaleNumber - 1],
                                      value2: [User.currentUserId(): FieldValue.delete()])
        }
        
        if user.community1 == self.communityId {
            updateUser(withValue: [COMMUNITY1: ""])
        } else if user.community2 == self.communityId {
            updateUser(withValue: [COMMUNITY2: ""])
        } else if user.community3 == self.communityId {
            updateUser(withValue: [COMMUNITY3: ""])
        }
        
        fetchCurrentUser()
        fetchCommunity()
        setupWithdrawButton()
    }
    
    private func setupCommunityButton() {
        
        withdrawButton1.isHidden = false
        withdrawButton2.isHidden = false
        tweetButton1.isHidden = false
        tweetButton2.isHidden = false
        communityButton.setTitle("参加中", for: .normal)
        communityButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        communityButton.backgroundColor = UIColor.systemGray2
        communityButton.isEnabled = false
        widthConstraint.constant = 150
    }
    
    private func setupParticipationButton() {
        
        communityButton.setTitle("参加中", for: .normal)
        communityButton.setTitleColor(UIColor(named: O_BLACK), for: .normal)
        communityButton.backgroundColor = UIColor.systemGray2
        communityButton.isEnabled = false
        withdrawButton1.isHidden = false
        tweetButton1.isHidden = false
        widthConstraint.constant = 150
    }
    
    private func setupWithdrawButton() {
        
        communityButton.setTitle("コミュニティに参加する", for: .normal)
        communityButton.setTitleColor(UIColor.white, for: .normal)
        communityButton.backgroundColor = UIColor(named: O_GREEN)
        communityButton.isEnabled = true
        withdrawButton1.isHidden = true
        withdrawButton2.isHidden = true
        tweetButton1.isHidden = true
        tweetButton2.isHidden = true
        widthConstraint.constant = 300
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < -100 {
            topView.isHidden = false
            backButton1.isHidden = true
            withdrawButton1.isHidden = true
            tweetButton1.isHidden = true
        } else {
            topView.isHidden = true
            backButton1.isHidden = false
            
            if self.user.community1 == self.communityId {
                withdrawButton1.isHidden = false
                tweetButton1.isHidden = false
            } else if self.user.community2 == self.communityId {
                withdrawButton1.isHidden = false
                tweetButton1.isHidden = false
            } else if self.user.community3 == self.communityId {
                withdrawButton1.isHidden = false
                tweetButton1.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let toUserId = sender as! String
            detailVC.toUserId = toUserId
        }
        
        if segue.identifier == "TweetVC" {
            let tweetVC = segue.destination as! TweetTableViewController
            let communityId = sender as! String
            tweetVC.communityId = communityId
        }
    }
    
    private func setup() {
        
        topView.backgroundColor = .white
        withdrawButton1.isHidden = true
        withdrawButton2.isHidden = true
        tweetButton1.isHidden = true
        tweetButton2.isHidden = true
        communityButton.layer.cornerRadius = 44 / 2
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


// MARK: - Table view

extension CommunityUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommunityUsersTableViewCell
        cell.configureCell(self.community, self.user)
        
        return cell
    }
}

// MARK: - Collection view

extension CommunityUsersViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) == nil && indexPath.row == 0 || indexPath.row == 19 || indexPath.row == 38 || indexPath.row == 57 || indexPath.row == 76 || indexPath.row == 95 || indexPath.row == 114 || indexPath.row == 133 {
            
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! SearchCollectionViewCell
            //            cell3.bannerView.adUnitID = "ca-app-pub-4750883229624981/8611268051"
            //            cell3.bannerView.rootViewController = self
            //            cell3.bannerView.load(GADRequest())
            cell3.testBanner4()
            cell3.communityUsersCVC = self
            
            return cell3
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(users[indexPath.row - 1])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row - 1].uid)
        }
    }
}
