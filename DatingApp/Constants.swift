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
public let COLLECTION_MYPOST = Firestore.firestore().collection("myPost")
public let COLLECTION_MESSAGE = Firestore.firestore().collection("message")
public let COLLECTION_INBOX = Firestore.firestore().collection("inbox")
public let COLLECTION_LIKECOUNTER = Firestore.firestore().collection("likeCounter")
public let COLLECTION_TYPECOUNTER = Firestore.firestore().collection("typeCounter")
public let COLLECTION_MATCH = Firestore.firestore().collection("match")
public let COLLECTION_FEED = Firestore.firestore().collection("feed")
public let COLLECTION_SWIPE = Firestore.firestore().collection("swipe")
public let COLLECTION_REPORT = Firestore.firestore().collection("report")
public let COLLECTION_INQUIRY = Firestore.firestore().collection("inquiry")
public let COLLECTION_OPINION = Firestore.firestore().collection("opinion")
public let COLLECTION_BLOCK = Firestore.firestore().collection("block")
public let COLLECTION_COMMENT = Firestore.firestore().collection("comment")
public let COLLECTION_NOTICE = Firestore.firestore().collection("notice")

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
public let PROFILEIMAGEURL4 = "profileImageUrl4"
public let PROFILEIMAGEURL5 = "profileImageUrl5"
public let PROFILEIMAGEURL6 = "profileImageUrl6"
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
public let MYPAGEBADGECOUNT = "myPageBadgeCount"
public let APPBADGECOUNT = "appBadgeCount"
public let BLOOD = "blood"
public let EDUCATION = "education"
public let MARRIAGEHISTORY = "marriageHistory"
public let MARRIAGE = "marriage"
public let CHILD1 = "child1"
public let CHILD2 = "child2"
public let HOUSEMATE = "houseMate"
public let HOLIDAY = "holiday"
public let LIQUOR = "liquor"
public let TOBACCO = "tobacco"
public let BIRTHPLACE = "birthplace"
public let POSTCOUNT = "postCount"
public let HOBBY1 = "hobby1"
public let HOBBY2 = "hobby2"
public let HOBBY3 = "hobby3"
public let DETAILAREA = "detailArea"
public let SELECTEDGENRE = "selectedGenre"
public let REPORT = "report"
public let INQUIRY = "inquiry"
public let OPINION = "opinion"
public let POINTS = "points"
public let ONEDAY = "oneDay"
public let LOGINTIME = "loginTime"
public let ONEDAYLATE = "oneDaylate"
public let CREATED_AT = "created_at"
public let ITEM1 = "item1"
public let ITEM2 = "item2"
public let ITEM3 = "item3"
public let ITEM4 = "item4"
public let ITEM5 = "item5"
public let ITEM6 = "item6"
public let USEDITEM1 = "usedItem1"
public let USEDITEM2 = "usedItem2"
public let USEDITEM3 = "usedItem3"
public let USEDITEM4 = "usedItem4"
public let USEDITEM5 = "usedItem5"
public let USEDITEM6 = "usedItem6"
public let VISITED = "visited"

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

// MARK: - Like Type Match

public let ISLIKE = "isLike"
public let LIKED = "liked"
public let ISTYPE = "isType"
public let TYPED = "typed"
public let ISMATCH = "isMatch"


// MARK: - Footstep

public let ISFOOTSTEP = "isFootstep"
public let FOOTSTEPED = "footsteped"
public let TIMESTAMP = "timestamp"

// MARK: - Message

public let TO = "to"
public let FROM = "from"
public let MESSAGETEXT = "messageText"
public let DATE = "date"
public let ISREAD = "isRead"

// MARK: - Block
public let ISBLOCK = "isBlock"

// MARK: - Comment
public let TEXT = "text"

// MARL: - Notice
public let TITLE = "title"
public let TITLE2 = "title2"
public let MAINTEXT = "mainText"

// MARK: - Placeholder image

public let PLACEHOLDERIMAGEURL = "https://firebasestorage.googleapis.com/v0/b/datingapp-d0f98.appspot.com/o/images%2F2EB76E60-16FA-494F-9419-19905F13553C?alt=media&token=3c8906ed-1a5e-4370-8270-432dc0431ae5"

// MARK: - UserOfject

public let RCOMPLETION = "registerCompletion"
public let TO_VERIFIED_VC = "toVerifiedVC"
public let FEMALE = "female"
public let MALE = "male"
public let FOOTSTEP_ON = "footstep_on"
public let LIKE_ON = "like_on"
public let TYPE_ON = "type_on"
public let MATCH_ON = "match_on"
public let MESSAGE_ON = "message_on"

public let LOVER = "lover"
public let FRIEND = "friend"
public let MAILFRIEND = "mailfriend"
public let PLAY = "play"
public let FREE = "free"
public let LOVER2 = "lover2"
public let FRIEND2 = "friend2"
public let MAILFRIEND2 = "mailfriend2"
public let PLAY2 = "play2"
public let FREE2 = "free2"
public let WHITE = "white"
public let PINK = "pink"
public let GREEN = "green"
public let DARK = "dark"
public let REFRESH = "refresh"
public let CARDVC = "cardVC"
public let FACEBOOK = "facebook"
public let GOOGLE = "google"
public let FACEBOOK2 = "facebook2"
public let GOOGLE2 = "google2"
public let APPLE = "apple"
public let APPLE2 = "apple2"
public let DELETE = "delete"
public let ALL = "all"
public let HINT_END = "hint_end"
public let TUTORIAL_END = "tutorial_end"
public let MATCHING = "matching"
public let SEARCH_MINI = "search_mini"
public let LANKBAR = "lankBar"
public let FROM_SEARCHVC = "from_searchVC"
public let NOTICE1 = "notice1"
public let NOTICE2 = "notice2"
public let NOTICE3 = "notice3"
public let NOTICE4 = "notice4"
public let NOTICE5 = "notice5"
public let VIEW_ON = "view_on"

// MARK: - Notification

public let NOTIFICATION = "notification"
