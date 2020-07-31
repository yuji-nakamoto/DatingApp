//
//  MyPageTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class MyPageTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var user: User!
    private var myPosts = [Post]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchCurrentUser()
        fetchMyPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        fetchCurrentUser()
    }
    
    // MARK: - Fetch user
    
    private func fetchCurrentUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.tableView.reloadData()
        }
    }
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
            completion()
        }
    }
    
    // MARK: - Fetch my post
    
    private func fetchMyPost() {
        
        users.removeAll()
        myPosts.removeAll()
        
        Post.fetchMyPost() { (post) in
            guard let uid = post.uid else { return }
            self.fetchUser(uid) {
                self.myPosts.insert(post, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        navigationItem.title = "マイページ"
        
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            navigationController?.navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            tabBarController?.tabBar.tintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor(named: O_PINK)
        } else {
            navigationController?.navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
            tabBarController?.tabBar.tintColor = UIColor(named: O_BLACK)
            tabBarController?.tabBar.barTintColor = UIColor(named: O_GREEN)
        }
    }
    
}

// MARK: - Table view

extension MyPageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyPageTableViewCell
            
            cell.configureCell(user)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! PostTableViewCell
        
        let myPost = myPosts[indexPath.row - 1]
        cell.post = myPost
        cell.configureUserCell(user)
        return cell
    }
}
