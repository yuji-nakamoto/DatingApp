//
//  NoticeListTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NoticeListTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var noticeArray = [Notice]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotice()
        setupUI()
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch
    
    private func fetchNotice() {
        
        Notice.fetchNotice { (notice) in
            self.noticeArray.insert(notice, at: 0)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        navigationItem.title = "お知らせ"
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: WHITE) != nil {
            navigationItem.leftBarButtonItem?.tintColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
           navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }
}

// MARK: - Table view

extension NoticeListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeListTableViewCell
        
        cell.configureCell(noticeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 4 {
            UserDefaults.standard.set(true, forKey: NOTICE1)
            performSegue(withIdentifier: "NoticeVC", sender: nil)
        } else if indexPath.row == 3 {
            UserDefaults.standard.set(true, forKey: NOTICE2)
            performSegue(withIdentifier: "NoticeVC", sender: nil)
        } else if indexPath.row == 2 {
            UserDefaults.standard.set(true, forKey: NOTICE3)
            performSegue(withIdentifier: "NoticeVC", sender: nil)
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: NOTICE4)
            performSegue(withIdentifier: "NoticeVC", sender: nil)
        } else if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: NOTICE5)
            performSegue(withIdentifier: "NoticeVC", sender: nil)
        }
    }
}
