//
//  Counter.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/02.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation
import Firebase

// counters/${ID}
struct Counter {
    let numShards: Int
    
    init(numShards: Int) {
        self.numShards = numShards
    }
}

// counters/${ID}/shards/${NUM}
struct Shard {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
}
// [END counter_structs]

// [START create_counter]
func createCounter(ref: DocumentReference, numShards: Int) {
    ref.setData(["numShards": numShards]){ (err) in
        for i in 0...numShards {
            ref.collection("shards").document(String(i)).setData(["count": 0])
        }
    }
}
// [END create_counter]
// [START increment_counter]
func incrementCounter(ref: DocumentReference, numShards: Int) {
    // Select a shard of the counter at random
    let shardId = Int(arc4random_uniform(UInt32(numShards)))
    let shardRef = ref.collection("shards").document(String(shardId))
    
    shardRef.updateData([
        "count": FieldValue.increment(Int64(1))
    ])
}
// [END increment_counter]
// [START get_count]
func getCount(ref: DocumentReference) {
    ref.collection("shards").getDocuments() { (querySnapshot, err) in
        var totalCount = 0
        if err != nil {
            // Error getting shards
            // ...
        } else {
            for document in querySnapshot!.documents {
                let count = document.data()["count"] as! Int
                totalCount += count
            }
        }
        
        print("Total count is \(totalCount)")
    }
}
