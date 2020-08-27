//
//  Config.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/08/03.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import Foundation

let serverKey = "AAAAcl_4fVU:APA91bFkE3HWNc1ARQUAC21fylsA1JtzyIgL8Nge6O3BYHYTdaLoeyve9qa1lTW2goUJW0r57frVh-gfn8luFQK0uwB35bv69YH3wlxhMyAPVa6mT_9a3z-1muSRIl3GWnQ2XgSM1eeu"
let fcmUrl = "https://fcm.googleapis.com/fcm/send"

func sendRequestNotification(toUser: User, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/message\(toUser.uid!)",
        "notification": ["title": "メッセージ",
                          "body": message,
                          "badge": badge,
                          "sound": "default"
                          ]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}

func sendRequestNotification2(toUser: User, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/like\(toUser.uid!)",
        "notification": ["title": "お知らせ",
                          "body": message,
                          "badge": badge,
                          "sound": "default",
                          "content-available": true]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}

func sendRequestNotification3(toUser: User, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/type\(toUser.uid!)",
        "notification": ["title": "お知らせ",
                          "body": message,
                          "badge": badge,
                          "sound": "default",
                          "content-available": true]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}

func sendRequestNotification4(toUser: User, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/match\(toUser.uid!)",
        "notification": ["title": "マッチング",
                          "body": message,
                          "badge": badge,
                          "sound": "default",
                          "content-available": true]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}

func sendRequestNotification5(toUser: User, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to": "/topics/gift\(toUser.uid!)",
        "notification": ["title": "お知らせ",
                          "body": message,
                          "badge": badge,
                          "sound": "default",
                          "content-available": true]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(String(describing: response))")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
    }.resume()
}
