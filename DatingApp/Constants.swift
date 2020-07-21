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

public let COLLECTION_USER = Firestore.firestore().collection("user")

// MARK: - User

public let UID = "uid"
public let USERNAME = "username"
public let EMAIL = "email"
public let PROFILEIMAGEURLS = "profileImageUrls"
public let CURRENTUSER = "currentUser"
public let AGE = "age"
public let GENDER = "gender"
public let RESIDENCE = "residence"
public let PROFESSION = "profession"
public let SELFINTRO = "selfIntro"

// MARK: - UserOfject

public let RCOMPLETION = "registerCompletion"
public let TO_VERIFIED_VC = "toVerifiedVC"

