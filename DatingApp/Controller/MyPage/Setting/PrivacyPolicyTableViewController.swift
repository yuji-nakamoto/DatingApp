//
//  PrivacyPolicyTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/16.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class PrivacyPolicyTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "プライバシーポリシー"
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PrivacyPolicyTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PrivacyPolicyTableViewCell
        
        cell.setupUI()
        return cell
    }
}
