//
//  SendPostTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/31.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

class SendPostTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    private let userDefaults = UserDefaults.standard
    private var pleaceholderLbl = UILabel()
    private var user: User?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGenre()
        setupTextView()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        setupGenre()
    }
    
    // MARK: - Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if selectLabel.text == "選択してください" {
            hud.textLabel.text = "ジャンルを選択してください"
            hud.show(in: self.view)
            hudError()
            return
        }
        if textView.text.count == 0 {
            hud.textLabel.text = "文字を入力してください"
            hud.show(in: self.view)
            hudError()
            return
        }
        if textView.text.count > 30 {
            hud.textLabel.text = "30文字以下で入力してください"
            hud.show(in: self.view)
            hudError()
            return
        }
        
        let postId = UUID().uuidString
        let dict = [UID: User.currentUserId(),
                    GENDER: user!.gender!,
                    RESIDENCE: user!.residence!,
                    CAPTION: textView.text!,
                    GENRE: selectLabel.text!,
                    TIMESTAMP: Timestamp(date: Date()) ] as [String : Any]
        
        let dict2 = [UID: User.currentUserId(),
                     CAPTION: textView.text!,
                     GENRE: selectLabel.text!,
                     TIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        Post.savePost(postId, withValue: dict)
        Post.saveMyPost(postId, withValue: dict2)
        userDefaults.removeObject(forKey: LOVER)
        userDefaults.removeObject(forKey: FRIEND)
        userDefaults.removeObject(forKey: MAILFRIEND)
        userDefaults.removeObject(forKey: PLAY)
        userDefaults.removeObject(forKey: FREE)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Fetch user
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        navigationItem.title = "投稿内容"
        
        if userDefaults.object(forKey: FEMALE) != nil {
            sendButton.tintColor = UIColor.white
            navigationController?.navigationBar.barTintColor = UIColor(named: O_PINK)
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            sendButton.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.barTintColor = UIColor(named: O_GREEN)
            navigationController?.navigationBar.tintColor = UIColor(named: O_BLACK)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: O_BLACK) as Any]
        }
    }
    
    private func setupGenre() {
        
        if userDefaults.object(forKey: LOVER) != nil {
            selectLabel.text = "恋人募集"
        } else if userDefaults.object(forKey: FRIEND) != nil {
            selectLabel.text = "友達募集"
        } else if userDefaults.object(forKey: MAILFRIEND) != nil {
            selectLabel.text = "メル友募集"
        } else if userDefaults.object(forKey: PLAY) != nil {
            selectLabel.text = "遊びたい"
        } else if userDefaults.object(forKey: FREE) != nil {
            selectLabel.text = "ヒマしてる"
        }
    }
    
    private func setupTextView() {
        
        textView.delegate = self
        pleaceholderLbl.isHidden = false
        
        let pleaceholderX: CGFloat = self.view.frame.size.width / 75
        let pleaceholderY: CGFloat = -30
        let pleaceholderWidth: CGFloat = textView.bounds.width - pleaceholderX
        let pleaceholderHeight: CGFloat = textView.bounds.height
        let pleaceholderFontSize = self.view.frame.size.width / 25
        
        pleaceholderLbl.frame = CGRect(x: pleaceholderX, y: pleaceholderY, width: pleaceholderWidth, height: pleaceholderHeight)
        pleaceholderLbl.text = "30文字以内で入力してください"
        pleaceholderLbl.font = UIFont(name: "HelveticaNeue", size: pleaceholderFontSize)
        pleaceholderLbl.textColor = .systemGray4
        pleaceholderLbl.textAlignment = .left
        
        textView.addSubview(pleaceholderLbl)
    }

}

extension SendPostTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let spacing = CharacterSet.whitespacesAndNewlines
        
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            
            pleaceholderLbl.isHidden = true
        } else {
            pleaceholderLbl.isHidden = false
        }
    }
}