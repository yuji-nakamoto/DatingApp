//
//  DidTypeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/27.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class DidTypeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var types = [Type]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTypeUsers()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchTypeUsers()
        case 1: fetchtTypedUsers()
        default: break
        }
    }

    // MARK: - Fetch isLike
    
    private func fetchTypeUsers() {
        
        types.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypeUsers { (type) in
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.types.append(type)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Fetch liekd
    
    private func fetchtTypedUsers() {
        
        types.removeAll()
        users.removeAll()
        tableView.reloadData()
        
        Type.fetchTypedUser { (type) in
            guard let uid = type.uid else { return }
            self.fetchUser(uid: uid) {
                self.types.append(type)
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
        
        return types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let type = types[indexPath.row]
        cell.type = type
        cell.configureCell(users[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVC", sender: types[indexPath.row].uid)
    }
    
}
