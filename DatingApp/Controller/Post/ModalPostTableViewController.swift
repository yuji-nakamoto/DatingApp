//
//  ModalPostTableViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD

class ModalPostTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var pickerKeyBoard16: PickerKeyboard16!
    @IBOutlet weak var pickerKeyBoard17: PickerKeyboard17!
    @IBOutlet weak var pickerKeyBoard3: PickerKeyboard3!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var residenceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var genreLabel: UILabel!
    
    private var user = User()
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUser()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if genderLabel.text == "選択する" {
            hud.textLabel.text = "出会いたい人の性別を選択してください"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        let dict = [S_RESIDENCE: residenceLabel.text as Any,
                    SELECTEDGENRE: genreLabel.text as Any] as [String : Any]
        
        selectedPickerKeyboard()
        
        updateUser(withValue: dict as [String : Any])
        UserDefaults.standard.set(true, forKey: REFRESH)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func fetchUser() {
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            self.setupUserInfo(user)
        }
    }
    
    private func selectedPickerKeyboard() {
        
        if genderLabel.text == "男性" {
            updateUser(withValue: [SELECTGENDER: "男性"])
            UserDefaults.standard.set(true, forKey: MALE)
            UserDefaults.standard.set(true, forKey: REFRESH)
        } else if genderLabel.text == "女性" {
            updateUser(withValue: [SELECTGENDER: "女性"])
            UserDefaults.standard.removeObject(forKey: MALE)
            UserDefaults.standard.set(true, forKey: REFRESH)
        }
        
        if residenceLabel.text == "こだわらない" {
            UserDefaults.standard.set(true, forKey: ALL)
        } else {
            UserDefaults.standard.removeObject(forKey: ALL)
        }
        
        if genreLabel.text == "すべて" {
            UserDefaults.standard.removeObject(forKey: LOVER2)
            UserDefaults.standard.removeObject(forKey: FRIEND2)
            UserDefaults.standard.removeObject(forKey: MAILFRIEND2)
            UserDefaults.standard.removeObject(forKey: PLAY2)
            UserDefaults.standard.removeObject(forKey: FREE2)
        } else if genreLabel.text == "恋人募集" {
            UserDefaults.standard.set(true, forKey: LOVER2)
            UserDefaults.standard.removeObject(forKey: FRIEND2)
            UserDefaults.standard.removeObject(forKey: MAILFRIEND2)
            UserDefaults.standard.removeObject(forKey: PLAY2)
            UserDefaults.standard.removeObject(forKey: FREE2)
        } else if genreLabel.text == "友達募集" {
            UserDefaults.standard.set(true, forKey: FRIEND2)
            UserDefaults.standard.removeObject(forKey: LOVER2)
            UserDefaults.standard.removeObject(forKey: MAILFRIEND2)
            UserDefaults.standard.removeObject(forKey: PLAY2)
            UserDefaults.standard.removeObject(forKey: FREE2)
        } else if genreLabel.text == "メル友募集" {
            UserDefaults.standard.set(true, forKey: MAILFRIEND2)
            UserDefaults.standard.removeObject(forKey: FRIEND2)
            UserDefaults.standard.removeObject(forKey: LOVER2)
            UserDefaults.standard.removeObject(forKey: PLAY2)
            UserDefaults.standard.removeObject(forKey: FREE2)
        } else if genreLabel.text == "遊びたい" {
            UserDefaults.standard.set(true, forKey: PLAY2)
            UserDefaults.standard.removeObject(forKey: FRIEND2)
            UserDefaults.standard.removeObject(forKey: MAILFRIEND2)
            UserDefaults.standard.removeObject(forKey: LOVER2)
            UserDefaults.standard.removeObject(forKey: FREE2)
        } else if genreLabel.text == "ヒマしてる" {
            UserDefaults.standard.set(true, forKey: FREE2)
            UserDefaults.standard.removeObject(forKey: FRIEND2)
            UserDefaults.standard.removeObject(forKey: MAILFRIEND2)
            UserDefaults.standard.removeObject(forKey: PLAY2)
            UserDefaults.standard.removeObject(forKey: LOVER2)
        }
    }
    
    private func setupUserInfo(_ user: User) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            genderLabel.text = "男性"
        } else {
            genderLabel.text = "女性"
        }
        residenceLabel.text = user.sResidence
        
        if user.selectedGenre != "" {
            genreLabel.text = user.selectedGenre
        } else {
            genreLabel.text = "すべて"
        }
    }

    private func setupUI() {
        pickerKeyBoard3.delegate = self
        pickerKeyBoard16.delegate = self
        pickerKeyBoard17.delegate = self
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
        navigationItem.title = "検索条件"
        doneButton.layer.cornerRadius = 44 / 2
    }
}

extension ModalPostTableViewController: PickerKeyboard3Delegate {
    func titlesOfPickerViewKeyboard3(_ pickerKeyboard: PickerKeyboard3) -> Array<String> {
        return dataArray18
    }
    
    func didDone3(_ pickerKeyboard: PickerKeyboard3, selectData: String) {
        residenceLabel.text = selectData
    }
}

extension ModalPostTableViewController: PickerKeyboard16Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard16) -> Array<String> {
        return dataArray16
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard16, selectData: String) {
        genderLabel.text = selectData
    }
}

extension ModalPostTableViewController: PickerKeyboard17Delegate {
    func titlesOfPickerViewKeyboard(_ pickerKeyboard: PickerKeyboard17) -> Array<String> {
        return dataArray17
    }
    
    func didDone(_ pickerKeyboard: PickerKeyboard17, selectData: String) {
        genreLabel.text = selectData
    }
}
