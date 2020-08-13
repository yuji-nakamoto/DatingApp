//
//  NotVerifiedViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/13.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit

class NotVerifiedViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        descriptionLabel.text = "登録の際に入力したメールアドレスが、間違えている可能性が考えられます。\nメールアドレスをご確認のうえ、もう一度新規登録からやり直してみてください。"
        descriptionLabel2.text = "お使いのメールソフトの「迷惑メールフォルダ」や「ゴミ箱」に届いていないかご確認ください。"
        backButton.layer.cornerRadius = 50 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
