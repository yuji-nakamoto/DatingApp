//
//  CommunityAllViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/19.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class CommunityAllViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var communityArray = [Community]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCommunities()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: C_NUMBER_ON)
        UserDefaults.standard.removeObject(forKey: C_CREATED_ON)
        UserDefaults.standard.removeObject(forKey: C_ALL_ON)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchNumberCommunity() {
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.fetchNumberCommunity { (community) in
            self.communityArray.append(community)
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchCreatedCommunity() {
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.fetchCreatedCommunity { (community) in
            self.communityArray.append(community)
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    private func fetchCommunity() {
        
        indicator.startAnimating()
        communityArray.removeAll()
        Community.fetchAllCommunity { (community) in
            self.communityArray.append(community)
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
    private func fetchCommunities() {
        
        if UserDefaults.standard.object(forKey: C_NUMBER_ON) != nil {
            fetchNumberCommunity()
            navigationItem.title = "人気"
        } else if UserDefaults.standard.object(forKey: C_CREATED_ON) != nil {
            fetchCreatedCommunity()
            navigationItem.title = "新規"
        } else if UserDefaults.standard.object(forKey: C_ALL_ON) != nil {
            fetchCommunity()
            navigationItem.title = "すべて"
        }
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

extension CommunityAllViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  communityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommunityTableViewCell
        cell.configureCell(communityArray[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CommunityUsersVC", sender: communityArray[indexPath.row].communityId)
    }
}
