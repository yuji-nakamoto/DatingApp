//
//  HomeViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/22.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logout()
    }
    
    private func logout() {
        
        User.logoutUser { (error) in
            
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            self.toSelectLoginVC()
        }
    }
    
    private func toSelectLoginVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
            self.present(toSelectLoginVC, animated: true, completion: nil)
        }
    }
    
 

}
