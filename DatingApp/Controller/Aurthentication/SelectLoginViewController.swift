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
import AuthenticationServices
import CryptoKit
import CoreLocation
import Geofirestore

class SelectLoginViewController: UIViewController, GIDSignInDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var registertButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var hud = JGProgressHUD(style: .dark)
    private let manager = CLLocationManager()
    private var userLat = ""
    private var userLong = ""
    private let geofirestroe = GeoFirestore(collectionRef: COLLECTION_GEO)
    fileprivate var currentNonce: String?
    private var user = User()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confifureLocationManager()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func appleButtonPressed(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: APPLE)
        UserDefaults.standard.removeObject(forKey: GOOGLE)
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
        UserDefaults.standard.removeObject(forKey: APPLE)
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: - Facebook
    
    private func facebookSignIn() {
        
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
    
    // MARK: - Google
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        
        indicator.startAnimating()
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = error.localizedDescription
                self.setupHud()
                self.indicator.stopAnimating()
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
    
    private func authResult(authData: AuthDataResult) {
        
        let dict : [String: Any] = [
            UID: authData.user.uid,
            EMAIL: authData.user.email as Any,
            USERNAME: authData.user.displayName as Any,
            PROFILEIMAGEURL1: authData.user.photoURL?.absoluteString as Any]
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
            let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
            self.userLat = userLat
            self.userLong = userLong
        }
        
        if !self.userLat.isEmpty && !self.userLong.isEmpty {
            let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(self.userLat)!), longitude: CLLocationDegrees(Double(self.userLong)!))
            self.geofirestroe.setLocation(location: location, forDocumentWithID: User.currentUserId())
        }
        
        User.fetchUser(authData.user.uid) { (user) in
            self.user = user
            
            if self.user.uid == "" {
                saveUser(userId: authData.user.uid, withValue: dict)
                self.toEnterNameVC()
                self.indicator.stopAnimating()
                return
            }
            
            if UserDefaults.standard.object(forKey: GOOGLE) != nil && self.user.isGoogle == true {
                
                User.isOnline(online: "online") {}
                self.toTabBarVC()
            }
            self.indicator.stopAnimating()
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func setupUI() {
        
        descriptionLabel.text = "フリーでマッチしちゃおう！\n完全無料のマッチングアプリ\nフリマへようこそ！"
        appleButton.layer.cornerRadius = 44 / 2
        googleButton.layer.cornerRadius = 44 / 2
        mailButton.layer.cornerRadius = 44 / 2
        mailButton.layer.borderWidth = 1
        mailButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        registertButton.layer.cornerRadius = 44 / 2
        registertButton.layer.borderWidth = 1
        registertButton.layer.borderColor = UIColor(named: O_RED)?.cgColor
        
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
    
    private func toEnterNameVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toEnterNameVC = storyboard.instantiateViewController(withIdentifier: "EnterNameVC")
            self.present(toEnterNameVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Apple

extension SelectLoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            //            let userIdentifier = appleIDCredential.user
            //            let fullName = appleIDCredential.fullName
            indicator.startAnimating()
            let email = appleIDCredential.email
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    generator.notificationOccurred(.error)
                    self.hud.textLabel.text = error.localizedDescription
                    self.setupHud()
                    self.indicator.stopAnimating()
                    print("Error sing in apple", error.localizedDescription)
                    return
                    
                } else if let authData = result {
                    
                    let dict: [String: Any] = [
                        UID: authData.user.uid,
                        EMAIL: email as Any]
                    
                    if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
                        let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
                        self.userLat = userLat
                        self.userLong = userLong
                    }
                    
                    if !self.userLat.isEmpty && !self.userLong.isEmpty {
                        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(self.userLat)!), longitude: CLLocationDegrees(Double(self.userLong)!))
                        self.geofirestroe.setLocation(location: location, forDocumentWithID: User.currentUserId())
                    }
                    
                    User.fetchUser(authData.user.uid) { (user) in
                        self.user = user
                        if self.user.uid == "" {
                            saveUser(userId: authData.user.uid, withValue: dict)
                            self.toEnterNameVC()
                            self.indicator.stopAnimating()
                            return
                        }
                        
                        if UserDefaults.standard.object(forKey: APPLE) != nil && self.user.isApple == true {
                            User.isOnline(online: "online") {}
                            self.toTabBarVC()
                        }
                        self.indicator.stopAnimating()
                    }
                }
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "アプリはキーチェーンから選択した認証情報を受け取りました \n\n ユーザー名: \(username)\n パスワード: \(password)"
        let alertController = UIAlertController(title: "受け取ったキーチェーン資格情報",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension SelectLoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - CLLocationManagerDelegate

extension SelectLoginViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error location: \(error.localizedDescription) ")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        let updateLocation: CLLocation = locations.first!
        let newCordinate: CLLocationCoordinate2D = updateLocation.coordinate
        
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set("\(newCordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
    }
}
