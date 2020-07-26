//
//  DidSuperLikeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DidSuperLikeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var superlikes = [SuperLike]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSuperLikeUsers()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Fetch like
    
    private func fetchSuperLikeUsers() {
        SuperLike.fetchSuperLikeUsers { (superlikes) in
            self.superlikes = superlikes
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return superlikes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        cell.configureCell(superlikes[indexPath.row])
        
        return cell
    }
    
}
