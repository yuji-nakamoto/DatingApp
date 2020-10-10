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
public let COLLECTION_MESSAGE = Firestore.firestore().collection("message")
public let COLLECTION_INBOX = Firestore.firestore().collection("inbox")
public let COLLECTION_LIKECOUNTER = Firestore.firestore().collection("likeCounter")
public let COLLECTION_TYPECOUNTER = Firestore.firestore().collection("typeCounter")
public let COLLECTION_MATCH = Firestore.firestore().collection("match")
public let COLLECTION_SWIPE = Firestore.firestore().collection("swipe")
public let COLLECTION_REPORT = Firestore.firestore().collection("report")
public let COLLECTION_INQUIRY = Firestore.firestore().collection("inquiry")
public let COLLECTION_OPINION = Firestore.firestore().collection("opinion")
public let COLLECTION_BLOCK = Firestore.firestore().collection("block")
public let COLLECTION_COMMENT = Firestore.firestore().collection("comment")
public let COLLECTION_NOTICE = Firestore.firestore().collection("notice")
public let COLLECTION_GEO = Firestore.firestore().collection("geography")
public let COLLECTION_COMMUNITY = Firestore.firestore().collection("community")
public let COLLECTION_TWEET = Firestore.firestore().collection("tweet")
public let COLLECTION_REPLY = Firestore.firestore().collection("reply")
public let COLLECTION_TWEET_COMMENT = Firestore.firestore().collection("tweet_comment")
public let COLLECTION_FAVORITE = Firestore.firestore().collection("favorite")

// MARK: - Color

public let O_BLUE = "original_blue"
public let O_GREEN = "original_green"
public let O_BLACK = "original_black"
public let O_PINK = "original_pink"
public let O_DARK = "original_dark"
public let O_RED = "original_red"

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
public let S_RESIDENCE = "sResidence"
public let S_HEIGHT = "sHeight"
public let S_BODY = "sBody"
public let S_BLOOD = "sBlood"
public let S_PROFESSION = "sProfession"
public let STATUS = "status"
public let LASTCHANGE = "lastChanged"
public let MESSAGEBADGECOUNT = "messageBadgeCount"
public let MYPAGEBADGECOUNT = "myPageBadgeCount"
public let APPBADGECOUNT = "appBadgeCount"
public let COMMUNITYBADGECOUNT = "communityBadgeCount"
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
public let ONEDAYLATE = "oneDaylate"
public let CREATED_AT = "created_at"
public let ITEM1 = "item1"
public let ITEM2 = "item2"
public let ITEM3 = "item3"
public let ITEM4 = "item4"
public let ITEM5 = "item5"
public let ITEM6 = "item6"
public let ITEM7 = "item7"
public let ITEM8 = "item8"
public let ITEM9 = "item9"
public let USEDITEM2 = "usedItem2"
public let USEDITEM3 = "usedItem3"
public let USEDITEM5 = "usedItem5"
public let USEDITEM6 = "usedItem6"
public let USEDITEM7 = "usedItem7"
public let USEDITEM8 = "usedItem8"
public let VISITED = "visited"
public let POINTHALFLATE = "pointHalfLate"
public let ISCALL = "isCall"
public let CALLED = "called"
public let POINTBUTTON = "pointButton"
public let NEWLIKE = "newLike"
public let NEWTYPE = "newType"
public let NEWMESSAGE = "newMessage"
public let NEWMISSION = "newMission"
public let NEWREPLY = "newReply"
public let NEWCOMMENT = "newComment"
public let LATITUDE = "latitude"
public let LONGITUDE = "longitude"
public let ISAPPLE = "isApple"
public let ISGOOGLE = "isGoogle"
public let SEARCHMINI = "searchMini"
public let SELECTGENDER = "selectGender"
public let DAY = "day"
public let NEWUSER = "newUser"
public let MLOGINCOUNT = "mLoginCount"
public let MLIKECOUNT = "mLikeCount"
public let MTYPECOUNT = "mTypeCount"
public let MMESSAGECOUNT = "mMessageCount"
public let MMATCHCOUNT = "mMatchCount"
public let MFOOTCOUNT = "mFootCount"
public let MCOMMUNITYCOUNT = "mCommunityCount"
public let MCOMMUNITY = "mCommunity"
public let MPROFILE = "mProfile"
public let MKAIGAN = "mKaigan"
public let MTOSHI = "mToshi"
public let MMISSIONCLEAR = "mMissionClear"
public let LOGINGETPT1 = "loginGetPt1"
public let LOGINGETPT2 = "loginGetPt2"
public let LIKEGETPT1 = "likeGetPt1"
public let LIKEGETPT2 = "likeGetPt2"
public let TYPEGETPT1 = "typeGetPt1"
public let TYPEGETPT2 = "typeGetPt2"
public let MESSAGEGETPT1 = "messageGetPt1"
public let MESSAGEGETPT2 = "messageGetPt2"
public let MATCHGETPT1 = "matchGetPt1"
public let MATCHGETPT2 = "matchGetPt2"
public let FOOTGETPT1 = "footGetPt1"
public let FOOTGETPT2 = "footGetPt2"
public let COMMUNITYGETPT1 = "communityGetPt1"
public let COMMUNITYGETPT2 = "communityGetPt2"
public let COMMUNITYGETPT3 = "communityGetPt3"
public let COMMUNITYGETPT4 = "communityGetPt4"
public let PROFILEGETPT1 = "profileGetPt1"
public let KAIGANGETPT = "kaiganGetPt"
public let TOSHIGETPT = "toshiGetPt"
public let FURIMAPGETPT = "furimapGetPt"
public let MISSIONCLEARGETITEM = "missionClearGetItem"
public let COMMUNITY1 = "community1"
public let COMMUNITY2 = "community2"
public let COMMUNITY3 = "community3"
public let CREATECOMMUNITYCOUNT = "createCommunityCount"

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
public let MESSAGEID = "messageId"

// MARK: - Block
public let ISBLOCK = "isBlock"

// MARK: - Comment
public let TEXT = "text"

// MARK: - Notice
public let TITLE = "title"
public let TITLE2 = "title2"
public let MAINTEXT = "mainText"

// MARK: - Community
public let CONTENTSIMAGEURL = "contentsImageUrl"
public let COMMUNITYID = "communityId"
public let ALL_NUMBER = "all_number"
public let MALE_NUMBER = "male_number"
public let FEMALE_NUMBER = "female_number"
public let COMMUNITYLEADER = "communityLeader"

// MARK: - Tweet
public let TWEET = "tweet"
public let TWEETID = "tweetId"
public let TWEETCOUNT = "tweetCount"
public let COMMENTCOUNT = "commentCount"
public let COMMENTID = "commentId"
public let REPLY = "reply"
public let REPLYID = "replyId"
public let DATE2 = "date2"
public let ISREPLY = "isReply"
public let REPLYUSERID = "replyUserId"
public let LIKECOUNT2 = "likeCount2"
public let ISLIKE2 = "isLike2"

//MARK: - Favorite
public let ISFAVORITE = "isFavorite"

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
public let GIFT_ON = "gift_on"
public let REPLY_ON = "reply_on"
public let COMMENT_ON = "comment_on"
public let ISREAD_ON = "isRead_on"
public let DISTANCE_ON = "distance_on"

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
public let REFRESH = "refresh"
public let REFRESH2 = "refresh2"
public let REFRESH3 = "refresh3"
public let CARDVC = "cardVC"
public let FACEBOOK = "facebook"
public let GOOGLE = "google"
public let APPLE = "apple"
public let DELETE = "delete"
public let ALL = "all"
public let SORTLIKE = "sortLike"
public let HINT_END = "hint_end"
public let HINT_END2 = "hint_end2"
public let TUTORIAL_END = "tutorial_end"
public let MATCHING = "matching"
public let SEARCH_MINI_ON = "search_mini_on"
public let LANKBAR = "lankBar"
public let FROM_SEARCHVC = "from_searchVC"
public let NOTICE1 = "notice1"
public let NOTICE2 = "notice2"
public let NOTICE3 = "notice3"
public let NOTICE4 = "notice4"
public let NOTICE5 = "notice5"
public let VIEW_ON = "view_on"
public let REFRESH_ON = "refresh_on"
public let C_NUMBER_ON = "cNumber_on"
public let C_CREATED_ON = "cCreated_on"
public let C_RECOMMENDED_ON = "cRecommended_on"
public let C_SEARCH_ON = "cSearch_on"
public let RESIZE = "resize"

// MARK: - Notification

public let NOTIFICATION = "notification"
