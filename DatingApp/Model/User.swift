//
//  User.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    var age: Int!
    var selfIntro: String
    var residence: String
    var profession: String
    var gender: String
    
    init(uid: String, username: String, email: String, profileImageUrl: String, gender: String, age: Int, residence: String, profession: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.age = age
        self.gender = gender
        self.residence = residence
        self.profession = profession
        self.selfIntro = ""
    }
    
    init(dict: NSDictionary) {
        uid = dict[UID] as? String ?? ""
        username = dict[USERNAME] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        profileImageUrl = dict[PROFILEIMAGEURL] as? String  ?? ""
        age = dict[AGE] as? Int ?? 0
        gender = dict[GENDER] as? String ?? ""
        residence = dict[RESIDENCE] as? String ?? ""
        profession = dict[PROFESSION] as? String ?? ""
        selfIntro = dict[SELFINTRO] as? String ?? ""
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: CURRENTUSER) {
                return User.init(dict: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    // MARK: - Authentication func
    
    class func loginUser(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                
                if result!.user.isEmailVerified {
                    completion(error, true)
                    print("Success: email verified")
                } else {
                    print("Error: email is not verified")
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    class func createUser(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            completion(error)
            
            if error == nil {
                result!.user.sendEmailVerification { (error) in
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    class func resendVerificaitionEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            
            Auth.auth().currentUser?.reload(completion: { (error) in
                print("resend email error:", error?.localizedDescription as Any)
                completion(error)
            })
        })
    }
    
    class func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                print("error reset password: \(error!.localizedDescription)")
            }
            completion(error)
        }
    }
}

// MARK: - Helpers
func userDictFrom(_ user: User) -> NSDictionary {
    
    return NSDictionary(objects: [user.uid, user.email, user.profileImageUrl, user.age ?? 0, user.gender, user.profession, user.residence, user.username, user.selfIntro], forKeys: [UID as NSCopying, EMAIL as NSCopying, PROFILEIMAGEURL as NSCopying, AGE as NSCopying, GENDER as NSCopying, PROFESSION as NSCopying, RESIDENCE as NSCopying, USERNAME as NSCopying, SELFINTRO as NSCopying])
    
}

