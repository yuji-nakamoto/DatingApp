//
//  Authentication.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/26.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import Geofirestore

struct AuthService {

    // MARK: - Authentication func
    
    static func testLoginUser(email: String, password: String, comletion: @escaping() -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            comletion()
        }
    }
    
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
    
    static func logoutUser(completion: @escaping(_ error: Error?) -> Void) {
        
        User.isOnline(online: "offline") {
            Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
            Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
            Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
            Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")
            Messaging.messaging().unsubscribe(fromTopic: "gift\(Auth.auth().currentUser!.uid)")
            Messaging.messaging().unsubscribe(fromTopic: "comment\(Auth.auth().currentUser!.uid)")
            Messaging.messaging().unsubscribe(fromTopic: "reply\(Auth.auth().currentUser!.uid)")
            UserDefaults.standard.removeObject(forKey: RCOMPLETION)
            UserDefaults.standard.removeObject(forKey: GOOGLE)
            UserDefaults.standard.removeObject(forKey: FACEBOOK)
            UserDefaults.standard.removeObject(forKey: APPLE)
            UserDefaults.standard.removeObject(forKey: ISREAD_ON)
            UserDefaults.standard.removeObject(forKey: DISTANCE_ON)

            do {
                if let providerData = Auth.auth().currentUser?.providerData {
                    let userInfo = providerData[0]

                    switch userInfo.providerID {
                    case "google.com":
                        GIDSignIn.sharedInstance()?.signOut()
                    default:
                        break
                    }
                }
                try Auth.auth().signOut()
                completion(nil)
            } catch let error as NSError {
                print("Error sign out: \(error.localizedDescription)")
                completion(error)
            }
        }    
    }
    
    static func withdrawUser(completion: @escaping(_ error: Error?) -> Void) {
        let geofirestroe = GeoFirestore(collectionRef: COLLECTION_GEO)
        geofirestroe.removeLocation(forDocumentWithID: User.currentUserId())

        COLLECTION_USERS.document(User.currentUserId()).delete() { (_) in
            COLLECTION_COMMENT.document(User.currentUserId()).delete { (_) in
                COLLECTION_SWIPE.document(User.currentUserId()).delete { (_) in
                    COLLECTION_GEO.document(User.currentUserId()).delete { (_) in
                        Messaging.messaging().unsubscribe(fromTopic: "message\(Auth.auth().currentUser!.uid)")
                        Messaging.messaging().unsubscribe(fromTopic: "like\(Auth.auth().currentUser!.uid)")
                        Messaging.messaging().unsubscribe(fromTopic: "type\(Auth.auth().currentUser!.uid)")
                        Messaging.messaging().unsubscribe(fromTopic: "match\(Auth.auth().currentUser!.uid)")
                        Messaging.messaging().unsubscribe(fromTopic: "gift\(Auth.auth().currentUser!.uid)")
                        Messaging.messaging().unsubscribe(fromTopic: "comment\(Auth.auth().currentUser!.uid)")
                        Messaging.messaging().unsubscribe(fromTopic: "reply\(Auth.auth().currentUser!.uid)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            Auth.auth().currentUser?.delete(completion: { (error) in
                                
                                if error != nil {
                                    print("Error withdraw user: \(error!.localizedDescription)")
                                    completion(error)
                                } else {
                                    UserDefaults.standard.removeObject(forKey: RCOMPLETION)
                                    UserDefaults.standard.removeObject(forKey: GOOGLE)
                                    UserDefaults.standard.removeObject(forKey: FACEBOOK)
                                    UserDefaults.standard.removeObject(forKey: APPLE)
                                    UserDefaults.standard.removeObject(forKey: HINT_END)
                                    UserDefaults.standard.removeObject(forKey: HINT_END2)
                                    UserDefaults.standard.removeObject(forKey: TUTORIAL_END)
                                    UserDefaults.standard.removeObject(forKey: MALE)
                                    UserDefaults.standard.removeObject(forKey: FEMALE)
                                    UserDefaults.standard.removeObject(forKey: ISREAD_ON)
                                    UserDefaults.standard.removeObject(forKey: DISTANCE_ON)
                                    UserDefaults.standard.removeObject(forKey: SEARCH_MINI_ON)
                                    completion(error)
                                }
                            })
                        }
                    }
                }
            }
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
    
    static func changeEmail(email: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if let error = error {
                print("Error change email: \(error.localizedDescription)")
            } else {
                updateUser(withValue: [EMAIL: email])
            }
            completion(error)
        })
    }
    
    static func changePassword(password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                print("Error change password: \(error.localizedDescription)")
            }
            completion(error)
        })
    }
}
