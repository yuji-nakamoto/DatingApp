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
public let POST = "post"

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

public let PLACEHOLDERIMAGEURL = "https://firebasestorage.googleapis.com/v0/b/datingapp-d0f98.appspot.com/o/images%2FEC19D574-4963-4C1B-A4E5-54D645F1DA10?alt=media&token=9737006c-d65e-4366-9b6d-4a565e26373f"
public let PLACEHOLDERIMAGEURL2 = "https://firebasestorage.googleapis.com/v0/b/datingapp-d0f98.appspot.com/o/images%2F1F237C97-F09E-4F48-9C3A-AE4E75FCD004?alt=media&token=9ffc537e-3d1a-49aa-a03d-cc758b88e31d"

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





