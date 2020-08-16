//
//  SelectColorTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class SelectColorTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var checkButton1: UIButton!
    @IBOutlet weak var checkButton2: UIButton!
    @IBOutlet weak var checkButton3: UIButton!
    @IBOutlet weak var checkButton4: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        checkButton1.isHidden = true
        checkButton2.isHidden = true
        checkButton3.isHidden = true
        checkButton4.isHidden = true
        
        navigationItem.title = "テーマカラー"
        if UserDefaults.standard.object(forKey: WHITE) != nil {
            checkButton1.isHidden = false
            checkButton2.isHidden = true
            checkButton3.isHidden = true
            checkButton4.isHidden = true
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
        } else if UserDefaults.standard.object(forKey: PINK) != nil {
            checkButton1.isHidden = true
            checkButton2.isHidden = false
            checkButton3.isHidden = true
            checkButton4.isHidden = true
            navigationController?.navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else if UserDefaults.standard.object(forKey: GREEN) != nil {
            checkButton1.isHidden = true
            checkButton2.isHidden = true
            checkButton3.isHidden = false
            checkButton4.isHidden = true
            navigationController?.navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
        } else if UserDefaults.standard.object(forKey: DARK) != nil {
            checkButton1.isHidden = true
            checkButton2.isHidden = true
            checkButton3.isHidden = true
            checkButton4.isHidden = false
            navigationController?.navigationBar.barTintColor = UIColor(named: O_DARK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: WHITE)
            UserDefaults.standard.removeObject(forKey: PINK)
            UserDefaults.standard.removeObject(forKey: GREEN)
            UserDefaults.standard.removeObject(forKey: DARK)
            setupUI()
      
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: PINK)
            UserDefaults.standard.removeObject(forKey: WHITE)
            UserDefaults.standard.removeObject(forKey: GREEN)
            UserDefaults.standard.removeObject(forKey: DARK)
            setupUI()

        } else if indexPath.row == 2 {
            UserDefaults.standard.set(true, forKey: GREEN)
            UserDefaults.standard.removeObject(forKey: DARK)
            UserDefaults.standard.removeObject(forKey: PINK)
            UserDefaults.standard.removeObject(forKey: WHITE)
            setupUI()
        } else if indexPath.row == 3 {
            UserDefaults.standard.set(true, forKey: DARK)
            UserDefaults.standard.removeObject(forKey: GREEN)
            UserDefaults.standard.removeObject(forKey: PINK)
            UserDefaults.standard.removeObject(forKey: WHITE)
            setupUI()
        }        
    }
}
