//
//  CommunityTableViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/17.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class CommunityTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var communityArray1 = [Community]()
    private var communityArray2 = [Community]()
    private var communityArray3 = [Community]()
    private var user = User()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        UserDefaults.standard.removeObject(forKey: C_NUMBER_ON)
        UserDefaults.standard.removeObject(forKey: C_CREATED_ON)
        UserDefaults.standard.removeObject(forKey: C_RECOMMENDED_ON)
        UserDefaults.standard.removeObject(forKey: C_SEARCH_ON)
        fetchCurrentUser()
        fetchCommunity()
        fetchNumberCommunity()
        fetchCreatedCommunity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func myCommunityButtonPressed(_ sender: Any) {
        
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
            
            if self.user.community1 != "" && self.user.community2 != "" && self.user.community3 != "" {
                self.createButton.isEnabled = false
            } else {
                self.createButton.isEnabled = true
            }
            
            if self.user.createCommunity == true {
                self.createButton.isHidden = true
            }
        }
    }
    
    private func fetchNumberCommunity() {
        
        indicator.startAnimating()
        communityArray1.removeAll()
        Community.fetchNumberCommunity { (community) in
            self.communityArray1 = community
            self.collectionView1.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchCreatedCommunity() {
        
        indicator.startAnimating()
        communityArray2.removeAll()
        Community.fetchCreatedCommunity { (community) in
            self.communityArray2 = community
            self.collectionView2.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchCommunity() {
        
        indicator.startAnimating()
        communityArray3.removeAll()
        Community.fetchRecommendedCommunity { (community) in
            self.communityArray3 = community
            self.communityArray3.shuffle()
            self.collectionView3.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
    private func setupCollectionView() {
        
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView3.delegate = self
        collectionView3.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommunityUsersVC" {
            let communityUsersVC = segue.destination as! CommunityUsersViewController
            let communityId = sender as! String
            communityUsersVC.communityId = communityId
        }
    }
}

//MARK: CollectionView

extension CommunityTableViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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