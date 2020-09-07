//
//  WithdrawViewController.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/13.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import TextFieldEffects

class WithdrawViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var iconGoogle: UIImageView!
    @IBOutlet weak var iconApple: UIImageView!
    
    private var hud = JGProgressHUD(style: .dark)
    fileprivate var currentNonce: String?
    private var user = User()
    private let emailTextField = HoshiTextField(frame: CGRect(x: 40, y: 180, width: 300, height: 60))
    private let passwordTextField = HoshiTextField(frame: CGRect(x: 40, y: 240, width: 300, height: 60))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        doneButton.isEnabled = false
        
        if textFieldHaveText() {
            indicator.startAnimating()
            withdrawUser()
        } else {
            generator.notificationOccurred(.error)
            hud.textLabel.text = "入力欄を全て埋めてください。"
            hud.show(in: self.view)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2.0)
            doneButton.isEnabled = true
        }
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func appleButtonPressed(_ sender: Any) {
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Withdraw
    
    private func withdrawUser() {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("Error reauth: \(error.localizedDescription)")
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = "メールアドレス、もしくはパスワードが間違えています。"
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 3.0)
                self.doneButton.isEnabled = true
                self.indicator.stopAnimating()
            } else {
                AuthService.withdrawUser { (error) in
                    if let error = error {
                        print("Error withdraw: \(error.localizedDescription)")
                    } else {
                        self.hud.textLabel.text = "アカウントを削除しました。"
                        self.hud.show(in: self.view)
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.dismiss(afterDelay: 3.0)
                        self.toSelectLoginVC()
                        self.doneButton.isEnabled = true
                        self.indicator.stopAnimating()
                    }
                }
            }
        })
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
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                print("Error reauth: \(error.localizedDescription)")
                generator.notificationOccurred(.error)
                self.hud.textLabel.text = "アカウントが間違えています。"
                self.hud.show(in: self.view)
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(afterDelay: 3.0)
                self.doneButton.isEnabled = true
                self.indicator.stopAnimating()
            } else {
                AuthService.withdrawUser { (error) in
                    if let error = error {
                        print("Error withdraw: \(error.localizedDescription)")
                    } else {
                        self.hud.textLabel.text = "アカウントを削除しました。"
                        self.hud.show(in: self.view)
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.dismiss(afterDelay: 3.0)
                        self.toSelectLoginVC()
                        self.doneButton.isEnabled = true
                        self.indicator.stopAnimating()
                    }
                }
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.hud.textLabel.text = error.localizedDescription
        print(error.localizedDescription)
    }
    
    // MARK: - Helpers

    
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
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            
            if UserDefaults.standard.object(forKey: APPLE) != nil && self.user.isApple == true {
                self.appleButton.isHidden = false
                self.iconApple.isHidden = false
                self.iconGoogle.isHidden = true

            } else {
                self.appleButton.isHidden = true
                self.iconApple.isHidden = true
            }
            
            if UserDefaults.standard.object(forKey: GOOGLE) != nil && self.user.isGoogle == true {
                self.googleButton.isHidden = false
                self.iconGoogle.isHidden = false
                self.iconApple.isHidden = true

            } else {
                self.googleButton.isHidden = true
                self.iconGoogle.isHidden = true
            }
            
            if UserDefaults.standard.object(forKey: APPLE) != nil || UserDefaults.standard.object(forKey: GOOGLE) != nil {
                self.descriptionlabel.text = "退会ボタンを押すとアカウントが削除されます。"
                self.emailTextField.isHidden = true
                self.passwordTextField.isHidden = true
                self.doneButton.isHidden = true
            } else {
                self.descriptionlabel.text = "メールアドレスとパスワードを\n入力してください。"
            }
        }
        
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
        
        doneButton.layer.cornerRadius = 44 / 2
        backButton.layer.cornerRadius = 44 / 2
        appleButton.layer.cornerRadius = 44 / 2
        googleButton.layer.cornerRadius = 44 / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor(named: O_GREEN)?.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
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
    
    private func toSelectLoginVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let toSelectLoginVC = storyboard.instantiateViewController(withIdentifier: "SelectLoginVC")
            self.present(toSelectLoginVC, animated: true, completion: nil)
        }
    }
}

// MARK: - Apple

extension WithdrawViewController: ASAuthorizationControllerDelegate {
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
            
            indicator.startAnimating()
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if let error = error {
                    print("Error reauth: \(error.localizedDescription)")
                    generator.notificationOccurred(.error)
                    self.hud.textLabel.text = "エラーが発生しました。"
                    self.hud.show(in: self.view)
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.dismiss(afterDelay: 3.0)
                    self.appleButton.isEnabled = true
                    self.indicator.stopAnimating()
                } else {
                    AuthService.withdrawUser { (error) in
                        if let error = error {
                            print("Error withdraw: \(error.localizedDescription)")
                        } else {
                            self.hud.textLabel.text = "アカウントを削除しました。"
                            self.hud.show(in: self.view)
                            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            self.hud.dismiss(afterDelay: 3.0)
                            self.toSelectLoginVC()
                            self.appleButton.isEnabled = true
                            self.indicator.stopAnimating()
                        }
                    }
                }
            })
        }
    }
}

extension WithdrawViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
