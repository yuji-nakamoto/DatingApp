//
//  NoticeListTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/24.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

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
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchNotice() {
        
        Notice.fetchNoticeList { (notice) in
            self.noticeArray.append(notice)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        tableView.tableFooterView = UIView()
        navigationItem.title = "お知らせ"
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "NoticeVC", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "Notice2VC", sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "Notice3VC", sender: nil)
        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "Notice4VC", sender: nil)
        } else if indexPath.row == 4 {
            performSegue(withIdentifier: "Notice5VC", sender: nil)
        }
    }
}

extension NoticeListTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "お知らせはありません", attributes: attributes)
    }
}
