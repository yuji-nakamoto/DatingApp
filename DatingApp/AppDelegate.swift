//
//  AppDelegate.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import UserNotifications
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var user = User()
    let gcmMessageIDKey = "gcm.message_id"
    var timer = Timer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        timerMethod()
        getLoginBonus()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.sound, .badge, .alert]
            
            current.requestAuthorization(options: options) { (granted, error) in
                if error != nil {
                    
                } else {
                    Messaging.messaging().delegate = self
                    current.delegate = self
                    
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let types: UIUserNotificationType = [.sound, .badge, .alert]
            let setting = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(setting)
            application.registerForRemoteNotifications()
        }
        return true
    }
    
    private func timerMethod() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
    }
    
    private func getLoginBonus() {
        
        guard Auth.auth().currentUser != nil else { return }
        
        User.fetchUserAddSnapshotListener { (user) in
            self.user = user
            
            guard self.user.oneDayLate != nil else { return }
            
            let now = Timestamp()
            let nowDate = now.dateValue()
            let oneDayLate = user.oneDayLate.dateValue()
            
            if nowDate >= oneDayLate {
                let day = Date()
                let oneDayLate = Calendar.current.date(byAdding: .hour, value: 12, to: day)!
                updateUser(withValue: [ONEDAY: true, ONEDAYLATE: oneDayLate])
            }
        }
    }
    
    @objc func timeCount() {
        
        guard Auth.auth().currentUser != nil else { return }
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
        }
        
        guard user.uid != nil else { return }
        updateUser(withValue: [LOGINTIME: user.loginTime + 60])
    }
    
    func application(_ application: UIApplication,open url:URL,sourceApplication: String?,annotation: Any) -> Bool {
        var handled = false
        
        if url.absoluteString.contains("fb") {
            handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        } else {
            handled = GIDSignIn.sharedInstance()!.handle(url)
        }
        
        return handled
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID1: \(messageID)")
        }
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID2: \(messageID)")
        }
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate {
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID3: \(messageID)")
        }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            if notification.request.content.title == "メッセージ" {
                
                let dict = [MESSAGEBADGECOUNT: user.messageBadgeCount + 1,
                            APPBADGECOUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            } else if notification.request.content.title == "お知らせ" {
                
                let dict = [MYPAGEBADGECOUNT: user.myPageBadgeCount + 1,
                            APPBADGECOUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            } else if notification.request.content.title == "マッチング" {
                
                let dict = [MESSAGEBADGECOUNT: user.messageBadgeCount + 1,
                            APPBADGECOUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            }
        }
        
        completionHandler([.sound, .badge, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID4: \(messageID)")
        }
        
        User.fetchUser(User.currentUserId()) { (user) in
            self.user = user
            if response.notification.request.content.title == "メッセージ" {
                
                let dict = [MESSAGEBADGECOUNT: user.messageBadgeCount + 1,
                            APPBADGECOUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            } else if response.notification.request.content.title == "お知らせ" {
                
                let dict = [MYPAGEBADGECOUNT: user.myPageBadgeCount + 1,
                            APPBADGECOUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            } else if response.notification.request.content.title == "マッチング" {
                
                let dict = [MESSAGEBADGECOUNT: user.messageBadgeCount + 1,
                            APPBADGECOUNT: user.appBadgeCount + 1]
                updateUser(withValue: dict)
            }
        }
        
        print(userInfo)
        
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
}
