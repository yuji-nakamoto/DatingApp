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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
//        fetchUsers()
        sortResidence()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        sortResidence()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logout()
    }
    
    // MARK: - User
    
    private func fetchUsers() {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            
            User.fetchMaleUsers { (users) in
                self.users = users
                self.collectionView.reloadData()
                return
            }
        }
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            
            User.fetchFemaleUsers { (users) in
                self.users = users
                self.collectionView.reloadData()
            }
        }
    }
    
    private func sortResidence() {
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            
            User.fetchFemaleUser(User.currentUserId()) { (user) in
                let residence1 = user.residence
                User.maleResidenceSort(residence1!) { (users) in
                    print("!=nil")
                    self.users = users
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                User.fetchMaleUser(User.currentUserId()) { (user) in
                    let residence1 = user.residence
                    User.maleResidenceSort(residence1!) { (users) in
                        print("!=nil2")
                        self.users.append(contentsOf: users)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        if UserDefaults.standard.object(forKey: FEMALE) == nil {
            
            User.fetchMaleUser(User.currentUserId()) { (user) in
                let residence2 = user.residence
                User.femaleResidenceSort(residence2!) { (users) in
                    print("==nil")

                    self.users = users
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                User.fetchFemaleUser(User.currentUserId()) { (user) in
                    let residence2 = user.residence
                    User.femaleResidenceSort(residence2!) { (users) in
                        print("==nil2")

                        self.users.append(contentsOf: users)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Heplers
    
    private func logout() {
        
        User.logoutUser { (error) in
            
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            self.toSelectLoginVC()
        }
    }
    
    private func setupUI() {
        
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
        print("indexPath: \(indexPath.row)")

        performSegue(withIdentifier: "DetailVC", sender: users[indexPath.row])
    }
}
