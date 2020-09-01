//
//  SelectGenderTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/30.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class SelectGenderTableViewController: UITableViewController {
    
    @IBOutlet weak var checkMark1: UIButton!
    @IBOutlet weak var checkMark2: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        navigationItem.title = "出会いたい人の性別"

        if UserDefaults.standard.object(forKey: MALE) != nil {
            checkMark1.isHidden = true
            checkMark2.isHidden = false
        } else {
            checkMark2.isHidden = true
            checkMark1.isHidden = false
        }
        
        if UserDefaults.standard.object(forKey: PINK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            navigationItem.leftBarButtonItem?.tintColor = .white
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: REFRESH)
            UserDefaults.standard.removeObject(forKey: MALE)
            setupUI()
        } else {
            UserDefaults.standard.set(true, forKey: REFRESH)
            UserDefaults.standard.set(true, forKey: MALE)
            setupUI()
        }
    }
}