//
//  SelectLoginViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class SelectLoginViewController: UIViewController, GIDSignInDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var registertButton: UIButton!
    
    private var hud = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: FACEBOOK)
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = error.localizedDescription
                self.setupHud()
                print("Error email", error.localizedDescription)
                return
            }
            guard let accessToken = AccessToken.current else {
                self.hud.textLabel.text = "Faild to get access token"
                self.setupHud()
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    generator.notificationOccurred(.error)
                    self.hud.textLabel.text = error.localizedDescription
                    print("Error credential", error.localizedDescription)
                    self.setupHud()
                    return
                }
                if let authData = result {
                    self.authResult(authData: authData)
                }
            }
        }
    }
    
    @IBAction func mailButtonPressed(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: TO_VERIFIED_VC) != nil {
            toVerifiedVC()
            return
        }
        toLoginVC()
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: GOOGLE)
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Helpers
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = error.localizedDescription
                self.setupHud()
                print(error.localizedDescription)
                return
            }
            if let authData = result {
                self.authResult(authData: authData)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.hud.textLabel.text = error.localizedDescription
        self.setupHud()
        print(error.localizedDescription)
    }
    
    private func authResult(authData: AuthDataResult) {
        
        let dict : [String: Any] = [
            UID: authData.user.uid,
            EMAIL: authData.user.email as Any,
            USERNAME: authData.user.displayName as Any,
            PROFILEIMAGEURL1: authData.user.photoURL?.absoluteString as Any]
        
        if UserDefaults.standard.object(forKey: FACEBOOK) != nil && UserDefaults.standard.object(forKey: FACEBOOK2) == nil {
            
            saveUser(userId: authData.user.uid, withValue: dict)
            self.toEnterGenderVC()
            
        } else if UserDefaults.standard.object(forKey: GOOGLE) != nil && UserDefaults.standard.object(forKey: GOOGLE2) == nil {
            
            saveUser(userId: authData.user.uid, withValue: dict)
            self.toEnterGenderVC()
            
        } else if UserDefaults.standard.object(forKey: FACEBOOK) != nil && UserDefaults.standard.object(forKey: FACEBOOK2) != nil || UserDefaults.standard.object(forKey: GOOGLE) != nil && UserDefaults.standard.object(forKey: GOOGLE2) != nil {
            
            updateUser(withValue: dict)
            UserDefaults.standard.set(true, forKey: WHITE)
            self.toTabBarVC()
        }
    }
    
    private func setupUI() {
        
        descriptionLabel.text = "フリーでマッチングしちゃおう！\n完全無料のマッチングアプリ、\nフリマへようこそ！"
        facebookButton.layer.cornerRadius = 50 / 2
        googleButton.layer.cornerRadius = 50 / 2
        mailButton.layer.cornerRadius = 50 / 2
        mailButton.layer.borderWidth = 1
        mailButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        registertButton.layer.cornerRadius = 50 / 2
        registertButton.layer.borderWidth = 1
        registertButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    private func setupHud() {
        
        self.hud.show(in: self.view)
        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    // MARK: - Navigation
    
    private func toVerifiedVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verifiedVC = storyboard.instantiateViewController(withIdentifier: "VerifiedVC")
        self.present(verifiedVC, animated: true, completion: nil)
    }
    
    private func toLoginVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toLoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        self.present(toLoginVC, animated: true, completion: nil)
    }
    
    private func toEnterGenderVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toEnterGenderVC = storyboard.instantiateViewController(withIdentifier: "EnterGenderVC")
        self.present(toEnterGenderVC, animated: true, completion: nil)
    }
    
    private func toTabBarVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toTabBerVC = storyboard.instantiateViewController(withIdentifier: "TabBerVC")
        self.present(toTabBerVC, animated: true, completion: nil)
    }
}
