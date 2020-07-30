//
//  SearchViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK:  - Properties
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var users = [User]()
    private var user: User?
    private let refresh = UIRefreshControl()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavTabColor()
        fetchUser()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavTabColor()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        self.viewDidLoad()
        fetchUser()
    }
    
    @objc func update(){
        fetchUser()
        collectionView.reloadData()
        refresh.endRefreshing()
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        indicator.startAnimating()
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let residenceSerch = user.residenceSerch
            User.genderAndResidenceSort(residenceSerch!, user) { (users) in
                self.users = users
                self.collectionView.reloadData()
                self.indicator.stopAnimating()
            }
        }
    }

    // MARK: - Heplers
    
    private func setupUI() {
        
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupNavTabColor() {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            navigationItem.title = "男性をさがす"
            navigationController?.navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            tabBarController?.tabBar.tintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor(named: O_PINK)
        } else {
            navigationItem.title = "女性をさがす"
            navigationController?.navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
            tabBarController?.tabBar.tintColor = UIColor(named: O_BLACK)
            tabBarController?.tabBar.barTintColor = UIColor(named: O_GREEN)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {

            let detailVC = segue.destination as! DetailTableViewController
            detailVC.user = sender as! User
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

}

//MARK: CollectionView

extension SearchViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SearchCollectionViewCell
        
        cell.configureCell(users[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row])
    }
}
