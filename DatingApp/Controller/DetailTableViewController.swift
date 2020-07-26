//
//  DetailTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import SDWebImage

class DetailTableViewController: UIViewController {
    
    // MARK: - Propertis
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var profileImages = [UIImage]()
    var user = User()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImages()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Download images
    
    private func downloadImages() {
        
        if user.profileImageUrl2 == "" && user.profileImageUrl3 == "" {
            let profileImageUrls = [user.profileImageUrl1] as! [String]
            let imageUrls = profileImageUrls.map({ URL(string: $0) })
            
            for (_, url) in imageUrls.enumerated() {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.profileImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        } else if user.profileImageUrl3 == "" {
            let profileImageUrls = [user.profileImageUrl1, user.profileImageUrl2] as! [String]
            let imageUrls = profileImageUrls.map({ URL(string: $0) })
            
            for (_, url) in imageUrls.enumerated() {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.profileImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        } else {
            let profileImageUrls = [user.profileImageUrl1, user.profileImageUrl2, user.profileImageUrl3] as! [String]
            let imageUrls = profileImageUrls.map({ URL(string: $0) })
            
            for (_, url) in imageUrls.enumerated() {
                SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                    self.profileImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
}

//MARK: UICollectionViewDelegate

extension DetailTableViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 375, height: 425)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailCollectionViewCell
        
        cell.setupProfileImages(profileImage: profileImages[indexPath.row])
        return cell
    }
}


// MARK: - UITableViewDelegate
extension DetailTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
        
        cell.configureCell(user)

        return cell
    }
}
