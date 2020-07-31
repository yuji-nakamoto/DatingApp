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
    var age: Int!
    var gender: String!
    var selfIntro: String!
    var residence: String!
    var profession: String!
    var comment: String!
    var bodySize: String!
    var height: String!
    var minAge: Int!
    var maxAge: Int!
    var residenceSerch: String!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        username = dict[USERNAME] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        profileImageUrl1 = dict[PROFILEIMAGEURL1] as? String ?? ""
        profileImageUrl2 = dict[PROFILEIMAGEURL2] as? String ?? ""
        profileImageUrl3 = dict[PROFILEIMAGEURL3] as? String ?? ""
        age = dict[AGE] as? Int ?? 18
        gender = dict[GENDER] as? String ?? ""
        residence = dict[RESIDENCE] as? String ?? ""
        profession = dict[PROFESSION] as? String ?? ""
        selfIntro = dict[SELFINTRO] as? String ?? ""
        comment = dict[COMMENT] as? String ?? ""
        bodySize = dict[BODYSIZE] as? String ?? ""
        height = dict[HEIGHT] as? String ?? ""
        minAge = dict[MINAGE] as? Int ?? 18
        maxAge = dict[MAXAGE] as? Int ?? 60
        residenceSerch = dict[RESIDENCESEARCH] as? String ?? ""
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    // MARK: - Fetch user
    
    class func fetchUser(_ currentUserId: String, completion: @escaping(_ user: User) -> Void) {
        
        COLLECTION_USERS.document(currentUserId).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            //                        print("DEBUG: snapshot data \(snapshot!.data()!)")
            let user = User(dict: snapshot!.data()! as [String: Any])
            completion(user)
        }
    }
    
    class func fetchUsers(forCurrentUer user: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        let query = COLLECTION_USERS
            .whereField(AGE, isGreaterThanOrEqualTo: user.minAge!)
            .whereField(AGE, isLessThanOrEqualTo: user.maxAge!)
        
        query.getDocuments { (snapshot, error) in
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
    
    class func genderAndResidenceSort(_ residenceSearch: String, _ user: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            let usersRef = COLLECTION_USERS
                .whereField(GENDER, isEqualTo: "男性")
                .whereField(RESIDENCE, isEqualTo: residenceSearch)
                .whereField(AGE, isGreaterThanOrEqualTo: user.minAge!)
                .whereField(AGE, isLessThanOrEqualTo: user.maxAge!)
            
            usersRef.getDocuments { (snapshot, error) in
                
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
            let usersRef = COLLECTION_USERS
                .whereField(GENDER, isEqualTo: "女性")
                .whereField(RESIDENCE, isEqualTo: residenceSearch)
                .whereField(AGE, isGreaterThanOrEqualTo: user.minAge!)
                .whereField(AGE, isLessThanOrEqualTo: user.maxAge!)
            
            usersRef.getDocuments { (snapshot, error) in
                
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
