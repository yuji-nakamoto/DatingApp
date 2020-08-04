//
//  Constants.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

// MARK: - Firestore

public let COLLECTION_USERS = Firestore.firestore().collection("users")
public let COLLECTION_LIKE = Firestore.firestore().collection("like")
public let COLLECTION_TYPE = Firestore.firestore().collection("type")
public let COLLECTION_FOOTSTEP = Firestore.firestore().collection("footstep")
public let COLLECTION_POSTS = Firestore.firestore().collection("posts")
public let COLLECTION_MYPOSTS = Firestore.firestore().collection("myPosts")
public let COLLECTION_MESSAGE = Firestore.firestore().collection("message")
public let COLLECTION_INBOX = Firestore.firestore().collection("inbox")
public let COLLECTION_LIKECOUNTER = Firestore.firestore().collection("likeCounter")
public let COLLECTION_TYPECOUNTER = Firestore.firestore().collection("typeCounter")

// MARK: - Color

public let O_BLUE = "original_blue"
public let O_GREEN = "original_green"
public let O_BLACK = "original_black"
public let O_PINK = "original_pink"
public let O_DARK = "original_dark"

// MARK: - User

public let UID = "uid"
public let USERNAME = "username"
public let EMAIL = "email"
public let PROFILEIMAGEURL1 = "profileImageUrl1"
public let PROFILEIMAGEURL2 = "profileImageUrl2"
public let PROFILEIMAGEURL3 = "profileImageUrl3"
public let CURRENTUSER = "currentUser"
public let AGE = "age"
public let GENDER = "gender"
public let RESIDENCE = "residence"
public let PROFESSION = "profession"
public let SELFINTRO = "selfIntro"
public let COMMENT = "comment"
public let BODYSIZE = "bodySize"
public let HEIGHT = "height"
public let MINAGE = "minAge"
public let MAXAGE = "maxAge"
public let RESIDENCESEARCH = "residenceSerch"
public let STATUS = "status"
public let LASTCHANGE = "lastChanged"
public let MESSAGEBADGECOUNT = "messageBadgeCount"
public let APPBADGECOUNT = "appBadgeCount"
public let MYPAGEBADGECOUNT = "myPageBadgeCount"

// MARK: - Counter

public let SHARDS = "shards"
public let LIKE = "like"
public let TYPE = "type"
public let LIKECOUNT = "likeCount"
public let TYPECOUNT = "typeCount"

// MARK: - Post

public let CAPTION = "caption"
public let POSTID = "postId"
public let GENRE = "genre"

// MARK: - Like Tcype

public let ISLIKE = "isLike"
public let ISTYPE = "isType"

// MARK: - Footstep

public let ISFOOTSTEP = "isFootstep"
public let TIMESTAMP = "timestamp"

// MARK: - Message

public let TO = "to"
public let FROM = "from"
public let MESSAGETEXT = "messageText"
public let DATE = "date"

// MARK: - Placeholder image

public let PLACEHOLDERIMAGEURL = "https://firebasestorage.googleapis.com/v0/b/datingapp-d0f98.appspot.com/o/images%2F2EB76E60-16FA-494F-9419-19905F13553C?alt=media&token=3c8906ed-1a5e-4370-8270-432dc0431ae5"

// MARK: - UserOfject

public let RCOMPLETION = "registerCompletion"
public let TO_VERIFIED_VC = "toVerifiedVC"
public let FEMALE = "female"
public let FOOTSTEP_ON = "footstep_on"
public let LOVER = "lover"
public let FRIEND = "friend"
public let MAILFRIEND = "mailfriend"
public let PLAY = "play"
public let FREE = "free"
public let WHITE = "white"
public let PINK = "pink"
public let GREEN = "green"
public let DARK = "dark"

// MARK: - Notification

public let NOTIFICATION = "notification"





