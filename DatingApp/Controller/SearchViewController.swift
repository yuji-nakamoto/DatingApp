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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var users = [User]()
    private var user: User?
    let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUser()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        fetchUser()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logout()
    }
    
    @objc func update(){
        fetchUser()
        collectionView.reloadData()
        refresh.endRefreshing()
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let residence = user.residence
            User.genderAndResidenceSort(residence!) { (users) in
                self.users = users
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - Heplers
    
    private func logout() {
        
        AuthService.logoutUser { (error) in
            
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            self.toSelectLoginVC()
        }
    }
    
    private func setupUI() {
        
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            navigationItem.title = "男性をさがす"
        } else {
            navigationItem.title = "女性をさがす"
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
    
    private func toSelectLoginVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
            self.present(toSelectLoginVC, animated: true, completion: nil)
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
