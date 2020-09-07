//
//  NoticeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/25.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NoticeTableViewController: UITableViewController {
    
    private var notice = Notice()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchNotice()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchNotice() {
        
        Notice.fetchNotice1 { (notice) in
            self.notice = notice
            self.tableView.reloadData()
        }
    }
    
    private func setupUI () {
        navigationItem.title = "お知らせ"
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeTableViewCell
        
        cell.notice(notice)
        return cell
    }
}
