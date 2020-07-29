//
//  FootstepTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/29.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class FootstepTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    private var footsteps = [Footstep]()
    private var users = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        fetchtFootStepedUsers()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentControlled(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: fetchtFootStepedUsers()
        case 1: fetchFootStepUsers()
        default: break
        }
    }

    // MARK: - Fetch isFootStep
    
    private func fetchFootStepUsers() {
        
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

    // MARK: - Fetch footSteped
    
    private func fetchtFootStepedUsers() {
        
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
            detailVC.typeUserId = userId
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
