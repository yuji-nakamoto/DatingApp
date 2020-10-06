//
//  CommunityTableCollectionViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/04.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class CommunityTableCollectionViewController: UITableViewController {

    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var communityButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var newLabel: UILabel!
    
    private var communityArray1 = [Community]()
    private var communityArray2 = [Community]()
    private var communityArray3 = [Community]()
    private var hud = JGProgressHUD(style: .dark)
    private var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.removeObject(forKey: C_NUMBER_ON)
        UserDefaults.standard.removeObject(forKey: C_CREATED_ON)
        UserDefaults.standard.removeObject(forKey: C_RECOMMENDED_ON)
        UserDefaults.standard.removeObject(forKey: C_SEARCH_ON)
        fetchCurrentUser()
        fetchCommunity()
        fetchNumberCommunity()
        fetchCreatedCommunity()
    }
    
    // MARK: - Actions
    
    @IBAction func createButtonPressed(_ sender: Any) {
        setupCreateButton(self.user)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: C_SEARCH_ON)
        performSegue(withIdentifier: "CommunityListVC", sender: nil)
    }
    
    @IBAction func allButton1Pressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: C_NUMBER_ON)
        performSegue(withIdentifier: "CommunityListVC", sender: nil)
    }
    
    @IBAction func allButton2Pressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: C_CREATED_ON)
        performSegue(withIdentifier: "CommunityListVC", sender: nil)
    }
    
    @IBAction func allButton3Pressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: C_RECOMMENDED_ON)
        performSegue(withIdentifier: "CommunityListVC", sender: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            
            if self.user.newReply == true {
                self.newLabel.isHidden = false
            } else {
                self.newLabel.isHidden = true
            }
        }
    }
    
    private func fetchNumberCommunity() {
        
        communityArray1.removeAll()
        Community.fetchNumberCommunity { (community) in
            self.communityArray1 = community
            self.collectionView1.reloadData()
        }
    }
    
    private func fetchCreatedCommunity() {
        
        communityArray2.removeAll()
        Community.fetchCreatedCommunity { (community) in
            self.communityArray2 = community
            self.collectionView2.reloadData()
        }
    }
    
    private func fetchCommunity() {
        
        communityArray3.removeAll()
        Community.fetchRecommendedCommunity { (community) in
            self.communityArray3 = community
            self.communityArray3.shuffle()
            self.collectionView3.reloadData()
        }
    }
    
    // MARK: - Helpers

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommunityUsersVC" {
            let communityUsersVC = segue.destination as! CommunityUsersViewController
            let communityId = sender as! String
            communityUsersVC.communityId = communityId
        }
    }
    
    private func setupCreateButton(_ user: User) {
        
        if user.community1 != "" && user.community2 != "" && user.community3 != "" && user.createCommunityCount >= 3 {
            hud.show(in: self.view)
            hud.textLabel.text = "作成数の上限に達しました"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        } else if user.community1 != "" && user.community2 != "" && user.community3 != "" {
            hud.show(in: self.view)
            hud.textLabel.text = "作成するには、参加中のコミュニティをどれか1つ退会してください"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        } else if user.createCommunityCount >= 3 {
            hud.show(in: self.view)
            hud.textLabel.text = "作成数の上限に達しました"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        performSegue(withIdentifier: "CreateComVC", sender: nil)
    }
    
    private func setup() {
        navigationItem.title = "コミュニティ"
        communityButton.layer.cornerRadius = 10
        createButton.layer.cornerRadius = 10
        newLabel.layer.cornerRadius = 9
    }
}

// MARK: - Collection view

extension CommunityTableCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView1 {
            return communityArray1.count
        } else if collectionView == self.collectionView2 {
            return communityArray2.count
        } else {
            return communityArray3.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommunityTableViewCell
            cell.configureCell(communityArray1[indexPath.row])
            
            return cell
        } else if collectionView == self.collectionView2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! CommunityTableViewCell
            cell.configureCell(communityArray2[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! CommunityTableViewCell
            cell.configureCell(communityArray3[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView1 {
            performSegue(withIdentifier: "CommunityUsersVC", sender: communityArray1[indexPath.row].communityId)
            
        } else if collectionView == self.collectionView2 {
            performSegue(withIdentifier: "CommunityUsersVC", sender: communityArray2[indexPath.row].communityId)
            
        } else {
            performSegue(withIdentifier: "CommunityUsersVC", sender: communityArray3[indexPath.row].communityId)
        }
    }
}
