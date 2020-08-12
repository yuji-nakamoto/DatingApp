//
//  FootstepTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift

class FootstepTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var topBannerView: GADBannerView!
    @IBOutlet weak var backView: UIView!
    
    
    private var footsteps = [Footstep]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBanner()
        fetchtFootstepedUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchtFootstepedUsers()
        case 1: fetchIsFootstepUsers()
        default: break
        }
    }

    // MARK: - Fetch
    
    private func fetchIsFootstepUsers() {
        
        footsteps.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Footstep.fetchFootstepUsers { (footStep) in
            guard let uid = footStep.uid else { return }
            self.fetchUser(uid: uid) {
                self.footsteps.append(footStep)
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchtFootstepedUsers() {
        
        footsteps.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Footstep.fetchFootstepedUser { (footStep) in
            guard let uid = footStep.uid else { return }
            self.fetchUser(uid: uid) {
                self.footsteps.append(footStep)
                self.tableView.reloadData()
            }
        }
    }
        
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
    
    // MARK: - Helpers
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
    }
    
    private func setupUI() {
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        navigationItem.title = "足あと"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_PINK)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            backView.backgroundColor = UIColor(named: O_GREEN)
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            backView.backgroundColor = UIColor.white
            backView.alpha = 0.85
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
            backView.backgroundColor = UIColor(named: O_DARK)
            backView.alpha = 0.85
        }
    }
}

// MARK: - Table view data source

extension FootstepTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return footsteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let footstep = footsteps[indexPath.row]
        cell.footstep = footstep
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: footsteps[indexPath.row].uid)
    }
}

extension FootstepTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        return NSAttributedString(string: "ユーザーの足あと、\nあなたの足あと履歴が、\nこちらに表示されます。", attributes: attributes)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "足あとを残したくない場合は、\nマイページにある歯車マークから\n設定ができます。")
    }
}
