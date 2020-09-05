//
//  VerifiedViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD
import CoreLocation
import Geofirestore
import Firebase
import TextFieldEffects

class VerifiedViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resendButton: UIButton!
    
    private var hud = JGProgressHUD(style: .dark)
    private let manager = CLLocationManager()
    private var userLat = ""
    private var userLong = ""
    private let geofirestroe = GeoFirestore(collectionRef: COLLECTION_GEO)
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 150, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 210, width: 300, height: 60))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confifureLocationManager()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginButton.isEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if textFieldHaveText() {
            
            loginButton.isEnabled = false
            loginUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        
        AuthService.resendVerificaitionEmail(email: emailTextField.text!) { (error) in
            print("Error: \(String(describing: error?.localizedDescription))")
        }
        hud.textLabel.text = "認証のメールを再送信しました。"
        hud.show(in: self.view)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.dismiss(afterDelay: 2.0)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - User
    
    private func loginUser() {
        
        self.activityIndicator.startAnimating()
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
            let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
            self.userLat = userLat
            self.userLong = userLong
        }
        
//                AuthService.testLoginUser(email: emailTextField.text!, password: passwordTextField.text!) {
//                    let dict = [UID: User.currentUserId(),
//                                EMAIL: self.emailTextField.text!] as [String : Any]
//                    saveUser(userId: User.currentUserId(), withValue: dict)
//                    self.toEnterNameVC()
//                    self.activityIndicator.stopAnimating()
//                }
        
        AuthService.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            if error == nil {
                
                if isEmailVerified {
                    
                    if !self.userLat.isEmpty && !self.userLong.isEmpty {
                        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(self.userLat)!), longitude: CLLocationDegrees(Double(self.userLong)!))
                        self.geofirestroe.setLocation(location: location, forDocumentWithID: User.currentUserId())
                    }
                    
                    self.hud.textLabel.text = "メールの認証に成功しました。"
                    self.hud.show(in: self.view)
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.dismiss(afterDelay: 2.0)
                    
                    let dict = [UID: User.currentUserId(),
                                EMAIL: self.emailTextField.text!] as [String : Any]
                    saveUser(userId: User.currentUserId(), withValue: dict)
                    
                    self.toEnterNameVC()
                } else {
                    generator.notificationOccurred(.error)
                    self.loginButton.isEnabled = true
                    self.hud.textLabel.text = "メールを確認してください。"
                    self.hud.show(in: self.view)
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.dismiss(afterDelay: 2.0)
                }
            } else {
                self.loginButton.isEnabled = true
                self.hud.textLabel.text = "メールアドレス、もしくはパスワードが間違えています。"
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 2.0)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
    private func confifureLocationManager() {
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    private func setupUI() {
        
        emailTextField.placeholderColor = UIColor(named: O_GREEN)!
        emailTextField.borderActiveColor = UIColor(named: O_RED)
        emailTextField.borderInactiveColor = UIColor(named: O_GREEN)
        emailTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        self.view.addSubview(emailTextField)
        
        passwordTextField.placeholderColor = UIColor(named: O_GREEN)!
        passwordTextField.borderActiveColor = UIColor(named: O_RED)
        passwordTextField.borderInactiveColor = UIColor(named: O_GREEN)
        passwordTextField.font = UIFont(name: "HiraMaruProN-W4", size: 18)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "パスワード"
        self.view.addSubview(passwordTextField)
        
        descriptionLabel.text = "メールに記載しているURLを開き、認証を完了させてください。"
        loginButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        resendButton.layer.cornerRadius = 44 / 2
        resendButton.layer.borderWidth = 1
        resendButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func textFieldHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    // MARK: - Navigation
    
    private func toEnterNameVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterNameVC = storyboard.instantiateViewController(withIdentifier: "EnterNameVC")
            self.present(toEnterNameVC, animated: true, completion: nil)
        }
    }
}

extension VerifiedViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error location: \(error.localizedDescription) ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let updateLocation: CLLocation = locations.first!
        let newCordinate: CLLocationCoordinate2D = updateLocation.coordinate
        
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set("\(newCordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
    }
}
