//
//  NoticeTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/25.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NoticeTableViewController: UITableViewController {
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: NOTICE1)
        UserDefaults.standard.removeObject(forKey: NOTICE2)
        UserDefaults.standard.removeObject(forKey: NOTICE3)
        UserDefaults.standard.removeObject(forKey: NOTICE4)
        UserDefaults.standard.removeObject(forKey: NOTICE5)

        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI () {
        
        navigationItem.title = "お知らせ"
        tableView.tableFooterView = UIView()
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
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeTableViewCell
        
        if UserDefaults.standard.object(forKey: NOTICE1) != nil {
            cell.notice1()
            return cell
        } else if UserDefaults.standard.object(forKey: NOTICE2) != nil {
            cell.notice2()
            return cell
        } else if UserDefaults.standard.object(forKey: NOTICE3) != nil {
            cell.notice3()
            return cell
        } else if UserDefaults.standard.object(forKey: NOTICE4) != nil {
            cell.notice4()
            return cell
        } else if UserDefaults.standard.object(forKey: NOTICE5) != nil {
            cell.notice5()
            return cell
        }

        return cell
    }
}
