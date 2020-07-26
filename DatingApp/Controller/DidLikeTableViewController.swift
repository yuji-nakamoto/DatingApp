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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLikeUsers()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Fetch like
    
    private func fetchLikeUsers() {
        Like.fetchLikeUsers { (likes) in
            self.likes = likes
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        cell.configureCell(likes[indexPath.row])
        
        return cell
    }
    
}
