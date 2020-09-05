//
//  ParchmentMessageViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/05.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Parchment

class ParchmentMessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "icon50"))
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let matchVC = storyboard.instantiateViewController(withIdentifier: "MatchCVC")
        let inboxVC = storyboard.instantiateViewController(withIdentifier: "InboxVC")
        let feedVC = storyboard.instantiateViewController(withIdentifier: "FeedVC")
        
        matchVC.title = "マッチング"
        inboxVC.title = "メッセージ"
        feedVC.title = "ひとこと"
        
        let pagingVC = PagingViewController(viewControllers: [matchVC, inboxVC, feedVC])
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
}
