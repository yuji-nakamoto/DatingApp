//
//  InboxTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class InboxTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var inboxArray = [Inbox]()
    private var inboxArrayDict = [String: Inbox]()
    private var user: User!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "メッセージ"
        tableView.tableFooterView = UIView()
        fetchInbox()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetBadge()
    }

    // MARK: - Fetch
    
    private func fetchInbox() {
        
        Message.fetchInbox { (inboxs) in
            inboxs.forEach { (inbox) in
                let message = inbox.message
                self.inboxArrayDict[message.chatPartnerId] = inbox
            }
            self.inboxArray = Array(self.inboxArrayDict.values)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MessageVC" {
            let messageVC = segue.destination as! MessageTebleViewController
            let userId = sender as! String
            messageVC.userId = userId
        }
        if segue.identifier == "DetailVC" {
            let detailVC = segue.destination as! DetailTableViewController
            let userId = sender as! String
            detailVC.userId = userId
        }
    }
    
    // MARK: - Helper
    
    private func resetBadge() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            let totalAppBadgeCount = user.appBadgeCount - user.messageBadgeCount
            
            updateUser(withValue: [MESSAGEBADGECOUNT: 0, APPBADGECOUNT: totalAppBadgeCount])
            UIApplication.shared.applicationIconBadgeNumber = totalAppBadgeCount
            self.tabBarController!.viewControllers![2].tabBarItem.badgeValue = nil
        }
    }
    
}

// MARK: - Table view

extension InboxTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inboxArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DidLikeTableViewCell
        
        let inbox = inboxArray[indexPath.row]
        cell.inbox = inbox
        cell.inboxVC = self
        cell.configureInboxCell(inboxArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MessageVC", sender: inboxArray[indexPath.row].message.chatPartnerId)
    }
}
