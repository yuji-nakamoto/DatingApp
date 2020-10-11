//
//  ParchmentCommunityViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/11.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Parchment

class ParchmentCommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let communityTVC = storyboard.instantiateViewController(withIdentifier: "CommunityTVC")
        let myCommunityVC = storyboard.instantiateViewController(withIdentifier: "MyCommunityVC")
        let replyListVC = storyboard.instantiateViewController(withIdentifier: "ReplyListVC")
        
        communityTVC.title = "コミュニティ"
        myCommunityVC.title = "マイコミュ"
        replyListVC.title = "通知"
        
        let pagingVC = PagingViewController(viewControllers: [communityTVC, myCommunityVC, replyListVC])
        addChild(pagingVC)
        view.addSubview(pagingVC.view)
        pagingVC.didMove(toParent: self)
        pagingVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pagingVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])
        
        pagingVC.font = UIFont(name: "HiraMaruProN-W4", size: 11)!
        pagingVC.selectedFont = UIFont(name: "HiraMaruProN-W4", size: 13)!
        pagingVC.selectedTextColor = .black
        pagingVC.indicatorColor = UIColor(named: O_RED)!
        pagingVC.menuItemSize = .fixed(width: 120, height: 40)
        pagingVC.menuHorizontalAlignment = .center
        
        navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraMaruProN-W4", size: 15)!]
    }
}
