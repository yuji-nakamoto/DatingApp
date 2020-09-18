//
//  ParchmentViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/03.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Parchment

class ParchmentViewController: UIViewController {
    
    @IBOutlet weak var switchButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func changeCollectionButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) == nil {
            UserDefaults.standard.set(true, forKey: SEARCH_MINI_ON)
            switchButton.setImage(UIImage(systemName: "circle.grid.2x2.fill"), for: .normal)
            updateUser(withValue: [SEARCHMINI: true])
        } else {
            UserDefaults.standard.removeObject(forKey: SEARCH_MINI_ON)
            switchButton.setImage(UIImage(systemName: "square.grid.4x3.fill"), for: .normal)
            updateUser(withValue: [SEARCHMINI: false])
        }
    }
    
    @IBAction func cardButtonPressed(_ sender: Any) {
        toCardVC()
    }
    
    // MARK: - Helpers
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC")
        let newLoginVC = storyboard.instantiateViewController(withIdentifier: "NewLoginVC")
        let newUserVC = storyboard.instantiateViewController(withIdentifier: "NewUserVC")
        let likeNationVC = storyboard.instantiateViewController(withIdentifier: "LikeNationVC")
        let likeCountVC = storyboard.instantiateViewController(withIdentifier: "LikeCountVC")
        
        searchVC.title = "さがす"
        newLoginVC.title = "ログイン順"
        newUserVC.title = "新規"
        likeNationVC.title = "全国いいね"
        likeCountVC.title = "地域いいね"
        
        let pagingVC = PagingViewController(viewControllers: [searchVC, newLoginVC, newUserVC, likeNationVC, likeCountVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
        ])
        
        pagingVC.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        pagingVC.selectedFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        pagingVC.selectedTextColor = .black
        pagingVC.indicatorColor = UIColor(named: O_RED)!
        pagingVC.menuItemSize = .fixed(width: 110, height: 40)
        pagingVC.menuHorizontalAlignment = .center
    }
    
    private func setupUI() {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            switchButton.setImage(UIImage(systemName: "circle.grid.2x2.fill"), for: .normal)
        } else {
            switchButton.setImage(UIImage(systemName: "square.grid.4x3.fill"), for: .normal)
        }
    }
    
    private func toCardVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toCardVC = storyboard.instantiateViewController(withIdentifier: "CardVC")
        self.present(toCardVC, animated: false, completion: nil)
    }
}
