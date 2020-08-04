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
    var likeCount: Int!
    var typeCount: Int!
    var lastChanged: Timestamp!
    var messageBadgeCount: Int!
    var appBadgeCount: Int!
    var myPageBadgeCount: Int!
    var blood: String!
    var education: String!
    var marriageHistory: String!
    var marriage: String!
    var child1: String!
    var child2: String!
    var houseMate: String!
    var holiday: String!
    var liquor: String!
    var tobacco: String!
    var birthplace: String!
    
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
        maxAge = dict[MAXAGE] as? Int ?? 40
        residenceSerch = dict[RESIDENCESEARCH] as? String ?? ""
        likeCount = dict[LIKECOUNT] as? Int ?? 0
        typeCount = dict[TYPECOUNT] as? Int ?? 0
        lastChanged = dict[LASTCHANGE] as? Timestamp ?? Timestamp(date: Date())
        messageBadgeCount = dict[MESSAGEBADGECOUNT] as? Int ?? 0
        appBadgeCount = dict[APPBADGECOUNT] as? Int ?? 0
        myPageBadgeCount = dict[MYPAGEBADGECOUNT] as? Int ?? 0
        birthplace = dict[BIRTHPLACE] as? String ?? ""
        blood = dict[BLOOD] as? String ?? ""
        education = dict[EDUCATION] as? String ?? ""
        marriageHistory = dict[MARRIAGEHISTORY] as? String ?? ""
        marriage = dict[MARRIAGE] as? String ?? ""
        child1 = dict[CHILD1] as? String ?? ""
        child2 = dict[CHILD2] as? String ?? ""
        liquor = dict[LIQUOR] as? String ?? ""
        tobacco = dict[TOBACCO] as? String ?? ""
        houseMate = dict[HOUSEMATE] as? String ?? ""
        holiday = dict[HOLIDAY] as? String ?? ""
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
//            print("DEBUG: snapshot data \(snapshot?.data())")
            guard snapshot?.data() != nil else { return }
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
    
    class func fetchTabBarBadgeCount(forCurrentId: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(forCurrentId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch badge count: \(error.localizedDescription)")
            }
            let user = User(dict: (snapshot?.data())!)
            completion(user)
        }
    }
    
    class func genderAndResidenceSort(_ residenceSearch: String, _ user: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        if UserDefaults.standard.object(forKey: FEMALE) != nil {
            let usersRef = COLLECTION_USERS
                .order(by: AGE)
                .order(by: LASTCHANGE)
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
                .order(by: AGE)
                .order(by: LASTCHANGE)
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
    
    class func isOnline(online: String) {
        
        guard Auth.auth().currentUser?.uid != nil else { return }
        let dict = [STATUS: online, LASTCHANGE: Timestamp(date: Date())] as [String : Any]
        COLLECTION_USERS.document(User.currentUserId()).updateData(dict)
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
