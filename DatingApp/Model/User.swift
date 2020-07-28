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
    var profileImageUrl1: String!
    var profileImageUrl2: String!
    var profileImageUrl3: String!
    var age: String!
    var gender: String!
    var selfIntro: String!
    var residence: String!
    var profession: String!
    var comment: String!
    var bodySize: String!
    var height: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        username = dict[USERNAME] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        profileImageUrl1 = dict[PROFILEIMAGEURL1] as? String ?? ""
        profileImageUrl2 = dict[PROFILEIMAGEURL2] as? String ?? ""
        profileImageUrl3 = dict[PROFILEIMAGEURL3] as? String ?? ""
        age = dict[AGE] as? String ?? ""
        gender = dict[GENDER] as? String ?? ""
        residence = dict[RESIDENCE] as? String ?? ""
        profession = dict[PROFESSION] as? String ?? ""
        selfIntro = dict[SELFINTRO] as? String ?? ""
        comment = dict[COMMENT] as? String ?? ""
        bodySize = dict[BODYSIZE] as? String ?? ""
        height = dict[HEIGHT] as? String ?? ""
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> User? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: CURRENTUSER) {
                return User.init(dict: dictionary as! [String: Any])
            }
        }
        return nil
    }
    
    // MARK: - Fetch user
    
    class func fetchUser(_ currentUserId: String, completion: @escaping(_ user: User) -> Void) {
        
        COLLECTION_USERS.document(currentUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
//            print("DEBUG: snapshot data \(snapshot!.data()!)")
            let user = User(dict: snapshot!.data()! as [String: Any])
            completion(user)
        }
    }
    
    class func fetchUsers(completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let user = User(dict: dictionary as [String: Any])
                users.append(user)
                
                if users.count == snapshot?.documents.count {
                    completion(users)
                }
            })
        }
    }
    
    class func genderAndResidenceSort(_ residence: String, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            
            COLLECTION_USERS
                .whereField(GENDER, isEqualTo: "男性")
                .whereField(RESIDENCE, isEqualTo: residence)
                .getDocuments { (snapshot, error) in
                    
                    if let error = error {
                        print("Error gender sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            users.append(user)
                        })
                    }
                    completion(users)
            }
        } else {
            COLLECTION_USERS
                .whereField(GENDER, isEqualTo: "女性")
                .whereField(RESIDENCE, isEqualTo: residence)
                .getDocuments { (snapshot, error) in
                    
                    if let error = error {
                        print("Error gender sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            users.append(user)
                        })
                    }
                    completion(users)
            }
        }
    }
    
}

// MARK: - Save Data

func saveUser(userId: String, withValue: [String: Any]) {
    
    COLLECTION_USERS.document(userId).setData(withValue) { (error) in
        if let error = error {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
}

func updateUser(withValue: [String: Any]) {
    
    COLLECTION_USERS.document(User.currentUserId()).updateData(withValue) { (error) in
        if let error = error {
            print("Error updating user: \(error.localizedDescription)")
        }
    }
}
