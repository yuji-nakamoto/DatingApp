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

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
        setupUI()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "icon50"))
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC")
        let newUserVC = storyboard.instantiateViewController(withIdentifier: "NewUserVC")
        let likeNationVC = storyboard.instantiateViewController(withIdentifier: "LikeNationVC")
        let likeCountVC = storyboard.instantiateViewController(withIdentifier: "LikeCountVC")
        
        searchVC.title = "さがす"
        newUserVC.title = "新規"
        likeNationVC.title = "全国いいね"
        likeCountVC.title = "地域いいね"
        
        let pagingVC = PagingViewController(viewControllers: [searchVC, newUserVC, likeNationVC, likeCountVC])
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
        pagingVC.indicatorColor = UIColor(named: O_GREEN)!
        pagingVC.menuItemSize = .fixed(width: 110, height: 40)
        pagingVC.menuHorizontalAlignment = .center
    }
    
    private func setupUI() {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) != nil {
            self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "circle.grid.2x2.fill")
        } else {
            self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "square.grid.4x3.fill")
        }
    }
    
    @IBAction func changeCollectionButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: SEARCH_MINI_ON) == nil {
            UserDefaults.standard.set(true, forKey: SEARCH_MINI_ON)
            self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "circle.grid.2x2.fill")
            updateUser(withValue: [SEARCHMINI: true])
        } else {
            UserDefaults.standard.removeObject(forKey: SEARCH_MINI_ON)
            self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "square.grid.4x3.fill")
            updateUser(withValue: [SEARCHMINI: false])
        }
    }
}
