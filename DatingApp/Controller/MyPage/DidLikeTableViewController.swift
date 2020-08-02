//
//  DidLikeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DidLikeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var likes = [Like]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchLikedUsers()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segementControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchLikedUsers()
        case 1: fetchLikeUsers()
        default: break
        }
    }
    
    // MARK: - Fetch like
    
    private func fetchLikeUsers() {
        
        likes.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Like.fetchLikeUsers { (like) in
            guard let uid = like.uid else { return }
            self.fetchUser(uid: uid) {
                self.likes.append(like)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch liekd
    
    private func fetchLikedUsers() {
        
        likes.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Like.fetchLikedUser { (like) in
            guard let uid = like.uid else { return }
            self.fetchUser(uid: uid) {
                self.likes.append(like)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch user
    private func fetchUser(uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.append(user)
            completion()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVC" {

            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    private func setupUI() {
        if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let like = likes[indexPath.row]
        cell.like = like
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: likes[indexPath.row].uid)
    }
    
}
