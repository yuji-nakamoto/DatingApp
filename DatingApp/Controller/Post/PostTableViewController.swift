//
//  PostTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import EmptyDataSet_Swift
import NVActivityIndicatorView

class PostTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var posts = [Post]()
    private var users = [User]()
    private var user: User?
    private let refresh = UIRefreshControl()
    private var activityIndicator: NVActivityIndicatorView?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        testBanner()
        
        setupUI()
        setupIndicator()
        fetchPost()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: REFRESH) != nil {
            fetchPost()
            UserDefaults.standard.removeObject(forKey: REFRESH)
        }
    }
    
    // MARK: - Actions
    
    @objc func refreshTableView(){
        fetchPost()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch post
    
    private func fetchPost() {
        guard Auth.auth().currentUser?.uid != nil else { return }
        
        showLoadingIndicator()
        posts.removeAll()
        users.removeAll()
        tableView.reloadData()
    
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let residence = user.sResidence
            
            if UserDefaults.standard.object(forKey: LOVER2) != nil {
                Post.fetchGenreLoverPosts(residence!) { (post) in
                    if post.uid == "" {
                        self.hideLoadingIndicator()
                        return
                    }
                    self.fetchUser(post.uid) {
                        self.posts.insert(post, at: 0)
                        self.hideLoadingIndicator()
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                    }
                }
            } else if UserDefaults.standard.object(forKey: FRIEND2) != nil {
                Post.fetchGenreFriendPosts(residence!) { (post) in
                    if post.uid == "" {
                        self.hideLoadingIndicator()
                        return
                    }
                    self.fetchUser(post.uid) {
                        self.posts.insert(post, at: 0)
                        self.hideLoadingIndicator()
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                    }
                }
            } else if UserDefaults.standard.object(forKey: MAILFRIEND2) != nil {
                Post.fetchGenreMailFriendPosts(residence!) { (post) in
                    if post.uid == "" {
                        self.hideLoadingIndicator()
                        return
                    }
                    self.fetchUser(post.uid) {
                        self.posts.insert(post, at: 0)
                        self.hideLoadingIndicator()
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                    }
                }
            } else if UserDefaults.standard.object(forKey: PLAY2) != nil {
                Post.fetchGenrePlayPosts(residence!) { (post) in
                    if post.uid == "" {
                        self.hideLoadingIndicator()
                        return
                    }
                    self.fetchUser(post.uid) {
                        self.posts.insert(post, at: 0)
                        self.hideLoadingIndicator()
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                    }
                }
            } else if UserDefaults.standard.object(forKey: FREE2) != nil {
                Post.fetchGenreFreePosts(residence!) { (post) in
                    if post.uid == "" {
                        self.hideLoadingIndicator()
                        return
                    }
                    self.fetchUser(post.uid) {
                        self.posts.insert(post, at: 0)
                        self.hideLoadingIndicator()
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                    }
                }
            } else {
                Post.fetchPosts(residence!) { (post) in
                    if post.uid == "" {
                        self.hideLoadingIndicator()
                        return
                    }
                    self.fetchUser(post.uid) {
                        self.posts.insert(post, at: 0)
                        self.hideLoadingIndicator()
                        self.tableView.reloadData()
                        self.refresh.endRefreshing()
                    }
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
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func setupIndicator() {
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 15 , y: self.view.frame.height / 2 - 150, width: 25, height: 25), type: .circleStrokeSpin, color: UIColor(named: O_BLACK), padding: nil)
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-4750883229624981/8230449518"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func testBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        UserDefaults.standard.removeObject(forKey: CARDVC)
        tableView.separatorStyle = .none
        tableView.refreshControl = refresh
        tableView.tableFooterView = UIView()
        navigationItem.title = "投稿"
        refresh.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

// MARK: - Table view

extension PostTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count == 0 ? 0 : 1 + posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 9 || indexPath.row == 18 || indexPath.row == 27 || indexPath.row == 36 || indexPath.row == 45 || indexPath.row == 54 || indexPath.row == 63 || indexPath.row == 72 || indexPath.row == 81 || indexPath.row == 90 || indexPath.row == 99 {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! AdsPostTableViewCell
            
            cell2.postVC = self
//            cell2.setupBanner()
            cell2.testBanner()
            return cell2
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row - 1]
        cell.post = post
        cell.configureUserCell(users[indexPath.row - 1])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            performSegue(withIdentifier: "DetailVC", sender: posts[indexPath.row - 1].uid)
        }
    }
}

extension PostTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "投稿は見つかりませんでした", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "しばらくお待ちになるか、\n検索条件を変更してみてください", attributes: attributes)
    }
}
