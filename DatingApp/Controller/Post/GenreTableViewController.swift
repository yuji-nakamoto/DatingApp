//
//  GenreTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class GenreTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var loverButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var mailfriendButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    
    private let userDefaults = UserDefaults.standard

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedGenre()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    private func selectedGenre() {
        navigationItem.title = "ジャンル"
        loverButton.isHidden = true
        friendButton.isHidden = true
        mailfriendButton.isHidden = true
        playButton.isHidden = true
        freeButton.isHidden = true
        
        if userDefaults.object(forKey: LOVER) != nil {
            loverButton.isHidden = false
            friendButton.isHidden = true
            mailfriendButton.isHidden = true
            playButton.isHidden = true
            freeButton.isHidden = true
        } else if userDefaults.object(forKey: FRIEND) != nil {
            loverButton.isHidden = true
            friendButton.isHidden = false
            mailfriendButton.isHidden = true
            playButton.isHidden = true
            freeButton.isHidden = true
        } else if userDefaults.object(forKey: MAILFRIEND) != nil {
            loverButton.isHidden = true
            friendButton.isHidden = true
            mailfriendButton.isHidden = false
            playButton.isHidden = true
            freeButton.isHidden = true
        } else if userDefaults.object(forKey: PLAY) != nil {
            loverButton.isHidden = true
            friendButton.isHidden = true
            mailfriendButton.isHidden = true
            playButton.isHidden = false
            freeButton.isHidden = true
        } else if userDefaults.object(forKey: FREE) != nil {
            loverButton.isHidden = true
            friendButton.isHidden = true
            mailfriendButton.isHidden = true
            playButton.isHidden = true
            freeButton.isHidden = false
        }
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            userDefaults.set(true, forKey: LOVER)
            userDefaults.removeObject(forKey: FRIEND)
            userDefaults.removeObject(forKey: MAILFRIEND)
            userDefaults.removeObject(forKey: PLAY)
            userDefaults.removeObject(forKey: FREE)
            selectedGenre()
            
        } else if indexPath.row == 1 {
            userDefaults.removeObject(forKey: LOVER)
            userDefaults.set(true, forKey: FRIEND)
            userDefaults.removeObject(forKey: MAILFRIEND)
            userDefaults.removeObject(forKey: PLAY)
            userDefaults.removeObject(forKey: FREE)
            selectedGenre()

        } else if indexPath.row == 2 {
            userDefaults.removeObject(forKey: LOVER)
            userDefaults.removeObject(forKey: FRIEND)
            userDefaults.set(true, forKey: MAILFRIEND)
            userDefaults.removeObject(forKey: PLAY)
            userDefaults.removeObject(forKey: FREE)
            selectedGenre()

        } else if indexPath.row == 3 {
            userDefaults.removeObject(forKey: LOVER)
            userDefaults.removeObject(forKey: FRIEND)
            userDefaults.removeObject(forKey: MAILFRIEND)
            userDefaults.set(true, forKey: PLAY)
            userDefaults.removeObject(forKey: FREE)
            selectedGenre()

        } else {
            userDefaults.removeObject(forKey: LOVER)
            userDefaults.removeObject(forKey: FRIEND)
            userDefaults.removeObject(forKey: MAILFRIEND)
            userDefaults.removeObject(forKey: PLAY)
            userDefaults.set(true, forKey: FREE)
            selectedGenre()
        }
    }
    
}
