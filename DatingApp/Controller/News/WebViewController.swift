//
//  WebViewController.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/10/07.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    var webVIew = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webVIew.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webVIew)
        
        let title = UserDefaults.standard.object(forKey: "title")
        navigationItem.title = title as? String
        
        let urlString = UserDefaults.standard.object(forKey: "url")
        let url = URL(string: urlString as! String)
        let request = URLRequest(url: url!)
        webVIew.load(request)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
