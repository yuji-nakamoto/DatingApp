//
//  Community.swift
//  DatingApp
//
//  Created by yuji nakamoto on 2020/09/18.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

class Community {
    
    var contentsImageUrl: String!
    var title: String!
    var number: Int!
    var communityId: String!
    var created_at: Timestamp!
    
    init() {
    }
    
    init(dict: [String: Any]) {
        contentsImageUrl = dict[CONTENTSIMAGEURL] as? String ?? ""
        title = dict[TITLE] as? String ?? ""
        number = dict[NUMBER] as? Int ?? 0
        communityId = dict[COMMUNITYID] as? String ?? ""
        created_at = dict[CREATED_AT] as? Timestamp ?? Timestamp(date: Date())
    }
    
    class func saveCommunity(communityId: String, withValue: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).setData(withValue)
        COLLECTION_COMMUNITY.document(communityId).collection("member").document(communityId).setData([User.currentUserId(): true])
    }
    
    class func updateCommunity(communityId: String, value1: [String: Any], value2: [String: Any]) {
        COLLECTION_COMMUNITY.document(communityId).updateData(value1)
        COLLECTION_COMMUNITY.document(communityId).collection("member").document(communityId).updateData(value2)
    }
    
    class func checkCommunity(communityId: String, completion: @escaping([String: Bool]) -> Void) {
        
        COLLECTION_COMMUNITY.document(communityId).collection("member").document(communityId).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else  {
                completion([String: Bool]())
                return
            }
            completion(data)
        }
    }
    
    class func fetchCommunity(communityId: String, completion: @escaping(Community) -> Void) {
        guard communityId != "" else { return }
        
        COLLECTION_COMMUNITY.document(communityId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch community: \(error.localizedDescription)")
            }
            
            guard let dict = snapshot?.data() else { return }
            let community = Community(dict: dict)
            completion(community)
        }
    }
    
    class func fetchAllCommunity(completion: @escaping([Community]) -> Void) {
        var communityArray = [Community]()

        COLLECTION_COMMUNITY.limit(to: 10).getDocuments { (snapshot,error) in
            if let error = error {
                print("Error fetch community: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let community = Community(dict: dict)
                communityArray.append(community)
            })
            completion(communityArray)
        }
    }
    
    class func fetchCreatedCommunity(completion: @escaping([Community]) -> Void) {
        var communityArray = [Community]()

        COLLECTION_COMMUNITY.order(by: CREATED_AT, descending: true).limit(to: 10).getDocuments { (snapshot,error) in
            if let error = error {
                print("Error fetch community: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let community = Community(dict: dict)
                communityArray.append(community)
            })
            completion(communityArray)
        }
    }
    
    class func fetchNumberCommunity(completion: @escaping([Community]) -> Void) {
        var communityArray = [Community]()

        COLLECTION_COMMUNITY.order(by: NUMBER, descending: true).limit(to: 10).getDocuments { (snapshot,error) in
            if let error = error {
                print("Error fetch community: \(error.localizedDescription)")
            }
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let community = Community(dict: dict)
                communityArray.append(community)
            })
            completion(communityArray)
        }
    }
    
    class func communitySearch(text: String, completion: @escaping([Community]) -> Void) {
        var communityArray = [Community]()
        
        if text == "" {
            completion(communityArray)
            return
        }
        
        COLLECTION_COMMUNITY.whereField(TITLE, isGreaterThanOrEqualTo: text).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetch community search: \(error.localizedDescription)")
            }
            
            snapshot?.documents.forEach({ (documents) in
                let dict = documents.data()
                let community = Community(dict: dict)
                communityArray.append(community)
            })
            completion(communityArray)
        }
    }
}
