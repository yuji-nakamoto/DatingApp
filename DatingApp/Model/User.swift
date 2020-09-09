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
    var profileImageUrl4: String!
    var profileImageUrl5: String!
    var profileImageUrl6: String!
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
    var created_at: Double!
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
    var postCount: Int!
    var hobby1: String!
    var hobby2: String!
    var hobby3: String!
    var detailArea: String!
    var selectedGenre: String!
    var report: String!
    var inquiry: String!
    var opinion: String!
    var isBlock: Int!
    var points: Int!
    var oneDay: Bool!
    var oneDayLate: Timestamp!
    var loginTime: Double!
    var item1: Int!
    var item2: Int!
    var item3: Int!
    var item4: Int!
    var item5: Int!
    var item6: Int!
    var item7: Int!
    var item8: Int!
    var usedItem1: Int!
    var usedItem2: Int!
    var usedItem3: Int!
    var usedItem4: Int!
    var usedItem5: Int!
    var usedItem6: Int!
    var usedItem7: Int!
    var usedItem8: Int!
    var visited: Int!
    var pointHalfLate: Timestamp!
    var isCall: Bool!
    var called: Bool!
    var newLike: Bool!
    var newType: Bool!
    var newMessage: Bool!
    var latitude: String!
    var longitude: String!
    var isApple: Bool!
    var isGoogle: Bool!
    var searchMini: Bool!
    var selectGender: String!
    var day: Double!
    var newUser: Bool!
    var monthLate: Timestamp!
    
    init() {
    }
        
    init(dict: [String: Any]) {
        uid = dict[UID] as? String ?? ""
        username = dict[USERNAME] as? String ?? ""
        email = dict[EMAIL] as? String ?? ""
        profileImageUrl1 = dict[PROFILEIMAGEURL1] as? String ?? ""
        profileImageUrl2 = dict[PROFILEIMAGEURL2] as? String ?? ""
        profileImageUrl3 = dict[PROFILEIMAGEURL3] as? String ?? ""
        profileImageUrl4 = dict[PROFILEIMAGEURL4] as? String ?? ""
        profileImageUrl5 = dict[PROFILEIMAGEURL5] as? String ?? ""
        profileImageUrl6 = dict[PROFILEIMAGEURL6] as? String ?? ""
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
        postCount = dict[POSTCOUNT] as? Int ?? 0
        hobby1 = dict[HOBBY1] as? String ?? ""
        hobby2 = dict[HOBBY2] as? String ?? ""
        hobby3 = dict[HOBBY3] as? String ?? ""
        detailArea = dict[DETAILAREA] as? String ?? ""
        created_at = dict[CREATED_AT] as? Double ?? 0
        selectedGenre = dict[SELECTEDGENRE] as? String ?? ""
        report = dict[REPORT] as? String ?? ""
        inquiry = dict[INQUIRY] as? String ?? ""
        opinion = dict[OPINION] as? String ?? ""
        isBlock = dict[ISBLOCK] as? Int ?? 0
        points = dict[POINTS] as? Int ?? 0
        oneDay = dict[ONEDAY] as? Bool ?? false
        oneDayLate = dict[ONEDAYLATE] as? Timestamp ?? Timestamp(date: Date())
        loginTime = dict[LOGINTIME] as? Double ?? 0
        item1 = dict[ITEM1] as? Int ?? 0
        item2 = dict[ITEM2] as? Int ?? 0
        item3 = dict[ITEM3] as? Int ?? 0
        item4 = dict[ITEM4] as? Int ?? 0
        item5 = dict[ITEM5] as? Int ?? 0
        item6 = dict[ITEM6] as? Int ?? 0
        item7 = dict[ITEM7] as? Int ?? 0
        item8 = dict[ITEM8] as? Int ?? 0
        usedItem1 = dict[USEDITEM1] as? Int ?? 0
        usedItem2 = dict[USEDITEM2] as? Int ?? 0
        usedItem3 = dict[USEDITEM3] as? Int ?? 0
        usedItem4 = dict[USEDITEM4] as? Int ?? 0
        usedItem5 = dict[USEDITEM5] as? Int ?? 0
        usedItem6 = dict[USEDITEM6] as? Int ?? 0
        usedItem7 = dict[USEDITEM7] as? Int ?? 0
        usedItem8 = dict[USEDITEM8] as? Int ?? 0
        visited = dict[VISITED] as? Int ?? 0
        pointHalfLate = dict[POINTHALFLATE] as? Timestamp ?? Timestamp(date: Date())
        isCall = dict[ISCALL] as? Bool ?? false
        called = dict[CALLED] as? Bool ?? false
        newLike = dict[NEWLIKE] as? Bool ?? false
        newType = dict[NEWTYPE] as? Bool ?? false
        newMessage = dict[NEWMESSAGE] as? Bool ?? false
        latitude = dict[LATITUDE] as? String ?? ""
        longitude = dict[LONGITUDE] as? String ?? ""
        isApple = dict[ISAPPLE] as? Bool ?? false
        isGoogle = dict[ISGOOGLE] as? Bool ?? false
        searchMini = dict[SEARCHMINI] as? Bool ?? false
        selectGender = dict[SELECTGENDER] as? String ?? ""
        day = dict[DAY] as? Double ?? 0
        newUser = dict[NEWUSER] as? Bool ?? false
        monthLate = dict[MONTHLATE] as? Timestamp ?? Timestamp(date: Date())
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
            if snapshot?.data() == nil {
                completion(User(dict: [UID: ""]))
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func fetchUsers(completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let user = User(dict: dictionary as [String: Any])
                completion(user)
            })
        }
    }
    
    class func fetchUserAddSnapshotListener(completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(User.currentUserId()).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch user add snapshot listener: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func fetchToUserAddSnapshotListener(toUserId: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(toUserId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetch to user add snapshot listener: \(error.localizedDescription)")
            }
            guard let dict = snapshot?.data() else { return }
            let user = User(dict: dict)
            completion(user)
        }
    }
    
    class func fetchCardUsers(_ currentUser: User, completion: @escaping(User) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)
            
            Service.fetchSwipe { (swipeUserIDs) in
                Block.fetchBlockSwipe { (blockUserIDs) in
                    Match.fetchMatch { (matchUserIDs) in
                        usersRef.getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error card sort: \(error.localizedDescription)")
                            } else {
                                if snapshot?.documents == [] {
                                    completion(User(dict: [UID: ""]))
                                }
                                snapshot?.documents.forEach({ (document) in
                                    let dict = document.data()
                                    let user = User(dict: dict as [String: Any])
                                    guard user.uid != User.currentUserId() else { return }
                                    guard user.gender == "男性" else { return }
                                    guard user.age <= currentUser.maxAge else { return }
                                    guard user.age >= currentUser.minAge else { return }
                                    guard user.residence == currentUser.residenceSerch else { return }
                                    guard swipeUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard blockUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard matchUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    completion(user)
                                })
                            }
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)
            
            Service.fetchSwipe { (swipeUserIDs) in
                Block.fetchBlockSwipe { (blockUserIDs) in
                    Match.fetchMatch { (matchUserIDs) in
                        usersRef.getDocuments { (snapshot, error) in

                            if let error = error {
                                print("Error card sort: \(error.localizedDescription)")
                            } else {
                                if snapshot?.documents == [] {
                                    completion(User(dict: [UID: ""]))
                                }
                                snapshot?.documents.forEach({ (document) in
                                    let dict = document.data()
                                    let user = User(dict: dict as [String: Any])

                                    guard user.uid != User.currentUserId() else { return }
                                    guard user.age <= currentUser.maxAge else { return }
                                    guard user.age >= currentUser.minAge else { return }
                                    guard user.gender == "女性" else { return }
                                    guard user.residence == currentUser.residenceSerch else { return }
                                    guard swipeUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard blockUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard matchUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    completion(user)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func fetchCardAllUsers(_ currentUser: User, completion: @escaping(User) -> Void) {
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)
            
            Service.fetchSwipe { (swipeUserIDs) in
                Block.fetchBlockSwipe { (blockUserIDs) in
                    Match.fetchMatch { (matchUserIDs) in
                        usersRef.getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print("Error card sort: \(error.localizedDescription)")
                            } else {
                                if snapshot?.documents == [] {
                                    completion(User(dict: [UID: ""]))
                                }
                                snapshot?.documents.forEach({ (document) in
                                    let dict = document.data()
                                    let user = User(dict: dict as [String: Any])
                                    guard user.uid != User.currentUserId() else { return }
                                    guard user.gender == "男性" else { return }
                                    guard user.age <= currentUser.maxAge else { return }
                                    guard user.age >= currentUser.minAge else { return }
                                    guard swipeUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard blockUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard matchUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    completion(user)
                                })
                            }
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)
            
            Service.fetchSwipe { (swipeUserIDs) in
                Block.fetchBlockSwipe { (blockUserIDs) in
                    Match.fetchMatch { (matchUserIDs) in
                        usersRef.getDocuments { (snapshot, error) in
                            
                            if let error = error {
                                print("Error card sort: \(error.localizedDescription)")
                            } else {
                                if snapshot?.documents == [] {
                                    completion(User(dict: [UID: ""]))
                                }
                                snapshot?.documents.forEach({ (document) in
                                    let dict = document.data()
                                    let user = User(dict: dict as [String: Any])
                                    guard user.uid != User.currentUserId() else { return }
                                    guard user.gender == "女性" else { return }
                                    guard user.age <= currentUser.maxAge else { return }
                                    guard user.age >= currentUser.minAge else { return }
                                    guard swipeUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard blockUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    guard matchUserIDs[user.uid] == nil else {
                                        completion(User(dict: [UID: ""]))
                                        return
                                    }
                                    completion(user)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func fetchUserResidenceSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS
                .order(by: USEDITEM2, descending: true)
                .order(by: LASTCHANGE)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "男性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.residence == currentUser.residenceSerch else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: USEDITEM2, descending: true)
                .order(by: LASTCHANGE)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "女性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.residence == currentUser.residenceSerch else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    class func fetchNationwide(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS
                .order(by: USEDITEM2, descending: true)
                .order(by: LASTCHANGE)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "男性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: USEDITEM2, descending: true)
                .order(by: LASTCHANGE)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        
                        if let error = error {
                            print("Error sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "女性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    class func fetchNewLoginSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)

            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "男性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.residence == currentUser.residenceSerch else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "女性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.residence == currentUser.residenceSerch else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    class func fetchNewLoginAll(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)

            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.gender == "男性" else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: LASTCHANGE)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.uid != User.currentUserId() else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.gender == "女性" else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    class func fetchNewUserSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS

            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.newUser == true else { return }
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "男性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.residence == currentUser.residenceSerch else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.newUser == true else { return }
                                guard user.uid != User.currentUserId() else { return }
                                guard user.gender == "女性" else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.residence == currentUser.residenceSerch else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    class func fetchNewUserAll(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS

            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.newUser == true else { return }
                                guard user.uid != User.currentUserId() else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.gender == "男性" else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        
                        if let error = error {
                            print("Error gender sort: \(error.localizedDescription)")
                        } else {
                            snapshot?.documents.forEach({ (document) in
                                let dict = document.data()
                                let user = User(dict: dict as [String: Any])
                                guard user.newUser == true else { return }
                                guard user.uid != User.currentUserId() else { return }
                                guard user.age <= currentUser.maxAge else { return }
                                guard user.age >= currentUser.minAge else { return }
                                guard user.gender == "女性" else { return }
                                guard blockUserIDs[user.uid] == nil else { return }
                                guard matchUserIDs[user.uid] == nil else { return }
                                users.append(user)
                            })
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    class func likeCountSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS
                .order(by: LIKECOUNT, descending: true)
                .limit(to: 30)

            Block.fetchBlockSwipe { (blockUserIDs) in
                usersRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error gender sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            guard user.gender == "男性" else { return }
                            guard user.residence == currentUser.residenceSerch else { return }
                            guard blockUserIDs[user.uid] == nil else { return }
                            users.append(user)
                        })
                        completion(users)
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: LIKECOUNT, descending: true)
                .limit(to: 30)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                usersRef.getDocuments { (snapshot, error) in
                    
                    if let error = error {
                        print("Error gender sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            guard user.gender == "女性" else { return }
                            guard user.residence == currentUser.residenceSerch else { return }
                            guard blockUserIDs[user.uid] == nil else { return }
                            users.append(user)
                        })
                        completion(users)
                    }
                }
            }
        }
    }
    
    class func likeCountSortNationwide(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        
        if UserDefaults.standard.object(forKey: MALE) != nil {
            
            let usersRef = COLLECTION_USERS
                .order(by: LIKECOUNT, descending: true)
                .limit(to: 30)
            
            Block.fetchBlockSwipe { (blockUserIDs) in
                usersRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            guard user.gender == "男性" else { return }
                            guard blockUserIDs[user.uid] == nil else { return }
                            users.append(user)
                        })
                        completion(users)
                    }
                }
            }
            
        } else {
            let usersRef = COLLECTION_USERS
                .order(by: LIKECOUNT, descending: true)
                .limit(to: 30)

            Block.fetchBlockSwipe { (blockUserIDs) in
                usersRef.getDocuments { (snapshot, error) in
                    
                    if let error = error {
                        print("Error sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            guard user.gender == "女性" else { return }
                            guard blockUserIDs[user.uid] == nil else { return }
                            users.append(user)
                        })
                        completion(users)
                    }
                }
            }
        }
    }
    
    class func isOnline(online: String, completion: @escaping() -> Void) {
        
        guard Auth.auth().currentUser?.uid != nil else { return }
        let date: Double = Date().timeIntervalSince1970
        let dict = [STATUS: online, LASTCHANGE: Timestamp(date: Date()), DATE: date] as [String : Any]
        COLLECTION_USERS.document(User.currentUserId()).updateData(dict) { (error) in
            completion()
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

func updateToUser(_ toUserId: String, withValue: [String: Any]) {
    
    COLLECTION_USERS.document(toUserId).updateData(withValue) { (error) in
        if let error = error {
            print("Error updating touser: \(error.localizedDescription)")
        }
    }
}

func updateCount(toUser: User, withValue: [String: Any]) {
    
    COLLECTION_USERS.document(toUser.uid).updateData(withValue) { (error) in
        if let error = error {
            print("Error updating count: \(error.localizedDescription)")
        }
    }
}
