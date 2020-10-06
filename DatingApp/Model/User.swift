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
    var height: Int!
    var minAge: Int!
    var maxAge: Int!
    var sResidence: String!
    var sHeight: Int!
    var sBody: String!
    var sBlood: String!
    var sProfession: String!
    var likeCount: Int!
    var typeCount: Int!
    var lastChanged: Timestamp!
    var created_at: Double!
    var messageBadgeCount: Int!
    var appBadgeCount: Int!
    var myPageBadgeCount: Int!
    var communityBadgeCount: Int!
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
    var item1: Int!
    var item2: Int!
    var item3: Int!
    var item4: Int!
    var item5: Int!
    var item6: Int!
    var item7: Int!
    var item8: Int!
    var item9: Int!
    var usedItem2: Int!
    var usedItem3: Int!
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
    var newMission: Bool!
    var newMessage: Bool!
    var newReply: Bool!
    var newComment: Bool!
    var latitude: String!
    var longitude: String!
    var isApple: Bool!
    var isGoogle: Bool!
    var searchMini: Bool!
    var selectGender: String!
    var day: Double!
    var newUser: Bool!
    var mLoginCount: Int!
    var mLikeCount: Int!
    var mTypeCount: Int!
    var mMessageCount: Int!
    var mMatchCount: Int!
    var mFootCount: Int!
    var mCommunityCount: Int!
    var mCommunity: Bool!
    var mProfile: Bool!
    var mKaigan: Bool!
    var mToshi: Bool!
    var mFurimap: Bool!
    var mMissionClear: Bool!
    var loginGetPt1: Bool!
    var loginGetPt2: Bool!
    var likeGetPt1: Bool!
    var likeGetPt2: Bool!
    var typeGetPt1: Bool!
    var typeGetPt2: Bool!
    var messageGetPt1: Bool!
    var messageGetPt2: Bool!
    var matchGetPt1: Bool!
    var matchGetPt2: Bool!
    var footGetPt1: Bool!
    var footGetPt2: Bool!
    var communityGetPt1: Bool!
    var communityGetPt2: Bool!
    var communityGetPt3: Bool!
    var communityGetPt4: Bool!
    var profileGetPt1: Bool!
    var kaiganGetPt: Bool!
    var toshiGetPt: Bool!
    var furimapGetPt: Bool!
    var missionClearGetItem: Bool!
    var community1: String!
    var community2: String!
    var community3: String!
    var createCommunityCount: Int!
    
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
        height = dict[HEIGHT] as? Int ?? 0
        minAge = dict[MINAGE] as? Int ?? 18
        maxAge = dict[MAXAGE] as? Int ?? 40
        sResidence = dict[S_RESIDENCE] as? String ?? ""
        sBody = dict[S_BODY] as? String ?? ""
        sBlood = dict[S_BLOOD] as? String ?? ""
        sHeight = dict[S_HEIGHT] as? Int ?? 0
        sProfession = dict[S_PROFESSION] as? String ?? ""
        likeCount = dict[LIKECOUNT] as? Int ?? 0
        typeCount = dict[TYPECOUNT] as? Int ?? 0
        lastChanged = dict[LASTCHANGE] as? Timestamp ?? Timestamp(date: Date())
        messageBadgeCount = dict[MESSAGEBADGECOUNT] as? Int ?? 0
        appBadgeCount = dict[APPBADGECOUNT] as? Int ?? 0
        myPageBadgeCount = dict[MYPAGEBADGECOUNT] as? Int ?? 0
        communityBadgeCount = dict[COMMUNITYBADGECOUNT] as? Int ?? 0
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
        item1 = dict[ITEM1] as? Int ?? 0
        item2 = dict[ITEM2] as? Int ?? 0
        item3 = dict[ITEM3] as? Int ?? 0
        item4 = dict[ITEM4] as? Int ?? 0
        item5 = dict[ITEM5] as? Int ?? 0
        item6 = dict[ITEM6] as? Int ?? 0
        item7 = dict[ITEM7] as? Int ?? 0
        item8 = dict[ITEM8] as? Int ?? 0
        item9 = dict[ITEM9] as? Int ?? 0
        usedItem2 = dict[USEDITEM2] as? Int ?? 0
        usedItem3 = dict[USEDITEM3] as? Int ?? 0
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
        newMission = dict[NEWMISSION] as? Bool ?? false
        newReply = dict[NEWREPLY] as? Bool ?? false
        newComment = dict[NEWCOMMENT] as? Bool ?? false
        latitude = dict[LATITUDE] as? String ?? ""
        longitude = dict[LONGITUDE] as? String ?? ""
        isApple = dict[ISAPPLE] as? Bool ?? false
        isGoogle = dict[ISGOOGLE] as? Bool ?? false
        searchMini = dict[SEARCHMINI] as? Bool ?? false
        selectGender = dict[SELECTGENDER] as? String ?? ""
        day = dict[DAY] as? Double ?? 0
        newUser = dict[NEWUSER] as? Bool ?? false
        mLoginCount = dict[MLOGINCOUNT] as? Int ?? 0
        mLikeCount = dict[MLIKECOUNT] as? Int ?? 0
        mTypeCount = dict[MTYPECOUNT] as? Int ?? 0
        mMessageCount = dict[MMESSAGECOUNT] as? Int ?? 0
        mMatchCount = dict[MMATCHCOUNT] as? Int ?? 0
        mFootCount = dict[MFOOTCOUNT] as? Int ?? 0
        mCommunityCount = dict[MCOMMUNITYCOUNT] as? Int ?? 0
        mCommunity = dict[MCOMMUNITY] as? Bool ?? false
        mProfile = dict[MPROFILE] as? Bool ?? false
        mKaigan = dict[MKAIGAN] as? Bool ?? false
        mToshi = dict[MTOSHI] as? Bool ?? false
        mFurimap = dict[MFURIMAP] as? Bool ?? false
        mMissionClear = dict[MMISSIONCLEAR] as? Bool ?? false
        loginGetPt1 = dict[LOGINGETPT1]as? Bool ?? false
        loginGetPt2 = dict[LOGINGETPT2]as? Bool ?? false
        likeGetPt1 = dict[LIKEGETPT1] as? Bool ?? false
        likeGetPt2 = dict[LIKEGETPT2] as? Bool ?? false
        typeGetPt1 = dict[TYPEGETPT1] as? Bool ?? false
        typeGetPt2 = dict[TYPEGETPT2] as? Bool ?? false
        messageGetPt1 = dict[MESSAGEGETPT1] as? Bool ?? false
        messageGetPt2 = dict[MESSAGEGETPT2] as? Bool ?? false
        matchGetPt1 = dict[MATCHGETPT1] as? Bool ?? false
        matchGetPt2 = dict[MATCHGETPT2] as? Bool ?? false
        footGetPt1 = dict[FOOTGETPT1] as? Bool ?? false
        footGetPt2 = dict[FOOTGETPT2] as? Bool ?? false
        communityGetPt1 = dict[COMMUNITYGETPT1] as? Bool ?? false
        communityGetPt2 = dict[COMMUNITYGETPT2] as? Bool ?? false
        communityGetPt3 = dict[COMMUNITYGETPT3] as? Bool ?? false
        communityGetPt4 = dict[COMMUNITYGETPT4] as? Bool ?? false
        profileGetPt1 = dict[PROFILEGETPT1] as? Bool ?? false
        kaiganGetPt = dict[KAIGANGETPT] as? Bool ?? false
        toshiGetPt = dict[TOSHIGETPT] as? Bool ?? false
        furimapGetPt = dict[FURIMAPGETPT] as? Bool ?? false
        missionClearGetItem = dict[MISSIONCLEARGETITEM] as? Bool ?? false
        community1 = dict[COMMUNITY1] as? String ?? ""
        community2 = dict[COMMUNITY2] as? String ?? ""
        community3 = dict[COMMUNITY3] as? String ?? ""
        createCommunityCount = dict[CREATECOMMUNITYCOUNT] as? Int ?? 0
    }
    
    // MARK: - Return user
    
    class func currentUserId() -> String {
        guard Auth.auth().currentUser != nil else { return "fCaTJRVce0eDLoxZAe2xLubNy893" }
        
        return Auth.auth().currentUser!.uid
    }
    
    // MARK: - Fetch user
    
    class func fetchUser(_ currentUserId: String, completion: @escaping(_ user: User) -> Void) {
        guard Auth.auth().currentUser != nil else { return }
        
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
        guard Auth.auth().currentUser != nil else { return }
        
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let user = User(dict: dictionary as [String: Any])
                completion(user)
            })
        }
    }
    
    class func fetchUserAddSnapshotListener(completion: @escaping(User) -> Void) {
        guard Auth.auth().currentUser != nil else { return }
        
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
        guard Auth.auth().currentUser != nil else { return }
        
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
        guard Auth.auth().currentUser != nil else { return }
        
        let usersRef = COLLECTION_USERS.order(by: LASTCHANGE)
        
        Service.fetchSwipe { (swipeUserIDs) in
            Block.fetchBlockSwipe { (blockUserIDs) in
                Match.fetchMatch { (matchUserIDs) in
                    usersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error card user: \(error.localizedDescription)")
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
                                
                                if UserDefaults.standard.object(forKey: MALE) != nil {
                                    guard user.gender == "男性" else { return }
                                } else {
                                    guard user.gender == "女性" else { return }
                                }
                                if UserDefaults.standard.object(forKey: ALL) == nil {
                                    guard user.residence == currentUser.sResidence else { return }
                                }
                                if UserDefaults.standard.object(forKey: HEIGHT) != nil {
                                    guard user.height >= currentUser.sHeight else { return }
                                }
                                if UserDefaults.standard.object(forKey: BODYSIZE) != nil {
                                    guard user.bodySize == currentUser.sBody else { return }
                                }
                                if UserDefaults.standard.object(forKey: BLOOD) != nil {
                                    guard user.blood == currentUser.sBlood else { return }
                                }
                                if UserDefaults.standard.object(forKey: PROFESSION) != nil {
                                    guard user.profession == currentUser.sProfession else { return }
                                }
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
    
    class func fetchUserSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        guard Auth.auth().currentUser != nil else { return }
        
        let usersRef = COLLECTION_USERS.order(by: USEDITEM2, descending: true)
        
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
                            
                            if UserDefaults.standard.object(forKey: MALE) != nil {
                                guard user.gender == "男性" else { return }
                            } else {
                                guard user.gender == "女性" else { return }
                            }
                            if UserDefaults.standard.object(forKey: ALL) == nil {
                                guard user.residence == currentUser.sResidence else { return }
                            }
                            if UserDefaults.standard.object(forKey: HEIGHT) != nil {
                                guard user.height >= currentUser.sHeight else { return }
                            }
                            if UserDefaults.standard.object(forKey: BODYSIZE) != nil {
                                guard user.bodySize == currentUser.sBody else { return }
                            }
                            if UserDefaults.standard.object(forKey: BLOOD) != nil {
                                guard user.blood == currentUser.sBlood else { return }
                            }
                            if UserDefaults.standard.object(forKey: PROFESSION) != nil {
                                guard user.profession == currentUser.sProfession else { return }
                            }
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
    
    class func fetchNewLoginSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        guard Auth.auth().currentUser != nil else { return }
        
        let usersRef = COLLECTION_USERS.order(by: LASTCHANGE, descending: true)
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            Match.fetchMatch { (matchUserIDs) in
                usersRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error new login sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            guard user.age <= currentUser.maxAge else { return }
                            guard user.age >= currentUser.minAge else { return }
                            
                            if UserDefaults.standard.object(forKey: MALE) != nil {
                                guard user.gender == "男性" else { return }
                            } else {
                                guard user.gender == "女性" else { return }
                            }
                            if UserDefaults.standard.object(forKey: ALL) == nil {
                                guard user.residence == currentUser.sResidence else { return }
                            }
                            if UserDefaults.standard.object(forKey: HEIGHT) != nil {
                                guard user.height >= currentUser.sHeight else { return }
                            }
                            if UserDefaults.standard.object(forKey: BODYSIZE) != nil {
                                guard user.bodySize == currentUser.sBody else { return }
                            }
                            if UserDefaults.standard.object(forKey: BLOOD) != nil {
                                guard user.blood == currentUser.sBlood else { return }
                            }
                            if UserDefaults.standard.object(forKey: PROFESSION) != nil {
                                guard user.profession == currentUser.sProfession else { return }
                            }
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
    
    class func fetchNewUserSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        guard Auth.auth().currentUser != nil else { return }
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            Match.fetchMatch { (matchUserIDs) in
                COLLECTION_USERS.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error new user sort: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.newUser == true else { return }
                            guard user.uid != User.currentUserId() else { return }
                            guard user.age <= currentUser.maxAge else { return }
                            guard user.age >= currentUser.minAge else { return }
                            
                            if UserDefaults.standard.object(forKey: MALE) != nil {
                                guard user.gender == "男性" else { return }
                            } else {
                                guard user.gender == "女性" else { return }
                            }
                            if UserDefaults.standard.object(forKey: ALL) == nil {
                                guard user.residence == currentUser.sResidence else { return }
                            }
                            if UserDefaults.standard.object(forKey: HEIGHT) != nil {
                                guard user.height >= currentUser.sHeight else { return }
                            }
                            if UserDefaults.standard.object(forKey: BODYSIZE) != nil {
                                guard user.bodySize == currentUser.sBody else { return }
                            }
                            if UserDefaults.standard.object(forKey: BLOOD) != nil {
                                guard user.blood == currentUser.sBlood else { return }
                            }
                            if UserDefaults.standard.object(forKey: PROFESSION) != nil {
                                guard user.profession == currentUser.sProfession else { return }
                            }
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
    
    class func likeCountSort(_ currentUser: User, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        guard Auth.auth().currentUser != nil else { return }
        
        let usersRef = COLLECTION_USERS.order(by: LIKECOUNT, descending: true).limit(to: 30)
        
        Block.fetchBlockSwipe { (blockUserIDs) in
            usersRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error like count sort: \(error.localizedDescription)")
                } else {
                    snapshot?.documents.forEach({ (document) in
                        let dict = document.data()
                        let user = User(dict: dict as [String: Any])
                        guard user.uid != User.currentUserId() else { return }
                        if UserDefaults.standard.object(forKey: MALE) != nil {
                            guard user.gender == "男性" else { return }
                        } else {
                            guard user.gender == "女性" else { return }
                        }
                        if UserDefaults.standard.object(forKey: ALL) == nil {
                            if UserDefaults.standard.object(forKey: SORTLIKE) == nil {
                                guard user.residence == currentUser.sResidence else { return }
                            }
                        }
                        guard blockUserIDs[user.uid] == nil else { return }
                        users.append(user)
                    })
                    completion(users)
                }
            }
        }
    }
    
    class func fetchCommunityUsers(communityId: String, completion: @escaping([User]) -> Void) {
        var users: [User] = []
        guard Auth.auth().currentUser != nil else { return }
                
        Block.fetchBlockSwipe { (blockUserIDs) in
            Community.checkCommunity(communityId: communityId) { (communityUserIDs) in
                COLLECTION_USERS.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetch community: \(error.localizedDescription)")
                    } else {
                        snapshot?.documents.forEach({ (document) in
                            let dict = document.data()
                            let user = User(dict: dict as [String: Any])
                            guard user.uid != User.currentUserId() else { return }
                            if UserDefaults.standard.object(forKey: MALE) != nil {
                                guard user.gender == "男性" else { return }
                            } else {
                                guard user.gender == "女性" else { return }
                            }
                            guard blockUserIDs[user.uid] == nil else { return }
                            guard communityUserIDs[user.uid] != nil else { return }
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
        let dict = [STATUS: online, LASTCHANGE: Timestamp(date: Date())] as [String : Any]
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
