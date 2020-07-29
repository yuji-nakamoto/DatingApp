//
//  Authentication.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/26.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

struct AuthService {
    
    // MARK: - Authentication func
    
    static func loginUser(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                
                if result!.user.isEmailVerified {
                    completion(error, true)
                } else {
                    completion(error, false)
                }
            } else {
                completion(error, false)
            }
        }
    }
    
    static func createUser(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            completion(error)
            
            if error == nil {
                result!.user.sendEmailVerification { (error) in
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    static func logoutUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: RCOMPLETION)
            completion(nil)
            
        } catch let error as NSError {
            completion(error)
        }
    }
    
    static func resendVerificaitionEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            
            Auth.auth().currentUser?.reload(completion: { (error) in
                print("resend email error:", error?.localizedDescription as Any)
                completion(error)
            })
        })
    }
    
    static func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                print("error reset password: \(error!.localizedDescription)")
            }
            completion(error)
        }
    }
}
