//
//  DetailTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/23.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DetailTableViewController: UIViewController {
    
    // MARK: - Propertis
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var profileImages = [UIImage]()
    var user = User()
        
    lazy var cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailTableViewCell
    
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
        
        Service.downloadImages(imageUrls: user.profileImageUrls) { (allImage) in
            self.profileImages = allImage as! [UIImage]
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in

            self.collectionView.collectionViewLayout.invalidateLayout()
            let indexPath = IndexPath(row: self.pageControl.currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
    }
    
}

//MARK: UICollectionViewDelegate

extension DetailTableViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 416, height: 385)
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
