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
    
    var uid: String!
    var username: String!
    var email: String!
    var profileImageUrls: [String]!
    var age: String!
    var selfIntro: String!
    var residence: String!
    var profession: String!
    
    init() {
    }
    
    init(dict: NSDictionary) {
        uid = dict[UID] as? String ?? ""
        username = dict[USERNAME] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        profileImageUrls = dict[PROFILEIMAGEURLS] as? [String]  ?? []
        age = dict[AGE] as? String ?? ""
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
                } else {
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
    
    class func logoutUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: RCOMPLETION)
            UserDefaults.standard.removeObject(forKey: FEMALE)
            UserDefaults.standard.removeObject(forKey: CURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)
            
        } catch let error as NSError {
            completion(error)
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
    
    // MARK: - Fetch user
    
    class func fetchMaleUser(_ currentUserId: String, completion: @escaping (_ user: User) -> Void) {
        
        COLLECTION_MALE_USERS.document(currentUserId).getDocument { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            let user = User(dict: snapshot!.data()! as NSDictionary)
            completion(user)
        }
    }
    
    class func fetchFemaleUser(_ currentUserId: String, completion: @escaping (_ user: User) -> Void) {
        
        COLLECTION_FEMALE_USERS.document(currentUserId).getDocument { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            let user = User(dict: snapshot!.data()! as NSDictionary)
            completion(user)
        }
    }
    
    class func fetchMaleUsers (completion: @escaping([User]) -> Void) {
        
        var users: [User] = []
        
        COLLECTION_MALE_USERS.getDocuments { (snapshot, error) in
            
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let user = User(dict: dictionary as NSDictionary)
                
                users.append(user)
                
                if users.count == snapshot?.documents.count {
                    completion(users)
                }
            })
        }
    }
    
    class func fetchFemaleUsers (completion: @escaping([User]) -> Void) {
        
        var users: [User] = []
        
        COLLECTION_FEMALE_USERS.getDocuments { (snapshot, error) in
            
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let user = User(dict: dictionary as NSDictionary)
                
                users.append(user)
                
                if users.count == snapshot?.documents.count {
                    completion(users)
                }
            })
        }
    }
    
    class func maleResidenceSort(_ withResidence: String, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        COLLECTION_MALE_USERS.whereField(RESIDENCE, isEqualTo: withResidence).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(users)
                return
            }
            if !snapshot.isEmpty {
                
                for userDict in snapshot.documents {
                    users.append(User(dict: userDict.data() as NSDictionary))
                }
            }
            completion(users)
        }
    }
    
    class func femaleResidenceSort(_ withResidence: String, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        COLLECTION_FEMALE_USERS.whereField(RESIDENCE, isEqualTo: withResidence).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(users)
                return
            }
            if !snapshot.isEmpty {
                
                for userDict in snapshot.documents {
                    users.append(User(dict: userDict.data() as NSDictionary))
                }
            }
            completion(users)
        }
    }
}

// MARK: - Helpers

func userDictFrom1(_ user: User) -> NSDictionary {
    
    return NSDictionary(objects: [user.uid ?? "", user.email ?? "", user.age ?? 0, user.username ?? ""], forKeys: [UID as NSCopying, EMAIL as NSCopying, AGE as NSCopying, USERNAME as NSCopying])
}

func userDictFrom2(_ user: User) -> NSDictionary {
    
    return NSDictionary(objects: [user.profileImageUrls ?? [], user.profession ?? "", user.residence ?? "", user.selfIntro ?? ""], forKeys: [PROFILEIMAGEURLS as NSCopying, PROFESSION as NSCopying, RESIDENCE as NSCopying, SELFINTRO as NSCopying])
}


func saveMaleUser(_ user: User) {
    
    COLLECTION_MALE_USERS.document(user.uid).setData(userDictFrom1(user) as! [String: Any]) { (error) in
        
        if error != nil {
            print("error saving user: \(error!.localizedDescription)")
        }
    }
}

func saveFemaleUser(_ user: User) {
    
    COLLECTION_FEMALE_USERS.document(user.uid).setData(userDictFrom1(user) as! [String: Any]) { (error) in
        
        if error != nil {
            print("error saving user: \(error!.localizedDescription)")
        }
    }
}

func updateMaleUserData1(_ user: User) {
    
    COLLECTION_MALE_USERS.document(user.uid).updateData(userDictFrom1(user) as! [AnyHashable : Any]) { (error) in
        
        if error != nil {
            print("error updating user: \(error!.localizedDescription)")
        }
    }
}

func updateMaleUserData2(_ user: User) {
    
    COLLECTION_MALE_USERS.document(user.uid).updateData(userDictFrom2(user) as! [AnyHashable : Any]) { (error) in
        
        if error != nil {
            print("error updating user: \(error!.localizedDescription)")
        }
    }
}

func updateFemaleUserData1(_ user: User) {
    
    COLLECTION_FEMALE_USERS.document(user.uid).updateData(userDictFrom1(user) as! [AnyHashable : Any]) { (error) in
        
        if error != nil {
            print("error updating user: \(error!.localizedDescription)")
        }
    }
}

func updateFemaleUserData2(_ user: User) {
    
    COLLECTION_FEMALE_USERS.document(user.uid).updateData(userDictFrom2(user) as! [AnyHashable : Any]) { (error) in
        
        if error != nil {
            print("error updating user: \(error!.localizedDescription)")
        }
    }
}
