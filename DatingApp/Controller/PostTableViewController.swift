//
//  PostTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class PostTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    
    private var posts = [Post]()
    private var users = [User]()
    private var user: User?
    private let refresh = UIRefreshControl()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fetchPost()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc func refreshTableView(){
        fetchPost()
        refresh.endRefreshing()
    }
    
    // MARK: - Fetch post
    
    private func fetchPost() {
        
        posts.removeAll()
        users.removeAll()
        tableView.reloadData()
    
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let residence = user.residenceSerch
            
            Post.fetchPosts(residence!) { (post) in
                guard let uid = post.uid else { return }
                self.fetchUser(uid) {
                    self.posts.insert(post, at: 0)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Fetch user
    
    private func fetchUser(_ uid: String, completion: @escaping() -> Void) {
        User.fetchUser(uid) { (user) in
            self.users.insert(user, at: 0)
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
    
    // MARK: - Helpers
    
    private func setupUI() {
        
        tableView.tableFooterView = UIView()
        navigationItem.title = "投稿"
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            plusButton.tintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            plusButton.tintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
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

extension PostTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        cell.post = post
        cell.configureUserCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: posts[indexPath.row].uid)
    }

}
