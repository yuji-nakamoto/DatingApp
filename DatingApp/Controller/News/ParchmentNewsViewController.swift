//
//  ParchmentNewsViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/08.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Parchment

class ParchmentNewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPagingVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func initPagingVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let news1VC = storyboard.instantiateViewController(withIdentifier: "News1VC")
        let news2VC = storyboard.instantiateViewController(withIdentifier: "News2VC")
        let news3VC = storyboard.instantiateViewController(withIdentifier: "News3VC")
        let news4VC = storyboard.instantiateViewController(withIdentifier: "News4VC")
        let news5VC = storyboard.instantiateViewController(withIdentifier: "News5VC")
        let news6VC = storyboard.instantiateViewController(withIdentifier: "News6VC")
        let news7VC = storyboard.instantiateViewController(withIdentifier: "News7VC")
        let news8VC = storyboard.instantiateViewController(withIdentifier: "News8VC")
        let news9VC = storyboard.instantiateViewController(withIdentifier: "News9VC")
        
        news1VC.title = "トレンド"
        news2VC.title = "エンタメ"
        news3VC.title = "スポーツ"
        news4VC.title = "IT"
        news5VC.title = "経済"
        news6VC.title = "国内"
        news7VC.title = "国際"
        news8VC.title = "科学"
        news9VC.title = "地域"
        
        let pagingVC = PagingViewController(viewControllers: [news1VC, news2VC, news3VC, news4VC, news5VC, news6VC, news7VC, news8VC, news9VC])
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
        pagingVC.menuItemSize = .fixed(width: 100, height: 40)
        pagingVC.menuHorizontalAlignment = .left
    }
}
