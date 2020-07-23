//
//  Constants.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import FirebaseFirestore

// MARK: - Firestore

public let COLLECTION_MALE_USERS = Firestore.firestore().collection("male_users")
public let COLLECTION_FEMALE_USERS = Firestore.firestore().collection("female_users")

// MARK: - Color

public let O_BLUE = "original_blue"
public let O_GREEN = "original_green"
public let O_BLACK = "original_black"


// MARK: - User

public let UID = "uid"
public let USERNAME = "username"
public let EMAIL = "email"
public let PROFILEIMAGEURLS = "profileImageUrls"
public let CURRENTUSER = "currentUser"
public let AGE = "age"
public let RESIDENCE = "residence"
public let PROFESSION = "profession"
public let SELFINTRO = "selfIntro"
public let COMMENT = "comment"
public let BODYSIZE = "bodySize"

// MARK: - UserOfject

public let RCOMPLETION = "registerCompletion"
public let TO_VERIFIED_VC = "toVerifiedVC"
public let FEMALE = "female"



