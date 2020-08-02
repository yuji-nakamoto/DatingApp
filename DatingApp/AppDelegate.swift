//
//  AppDelegate.swift
//  DatingApp
//
//  Created by yuji_nakamoto on 2020/07/21.
//  Copyright © 2020 yuji_nakamoto. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        keepUpdatingStatus()
        return true
    }
    
    func keepUpdatingStatus() {
        guard Auth.auth().currentUser?.uid != nil else { return }
        let database = Database.database()
        let uid = Auth.auth().currentUser!.uid
        
        database.reference(withPath: ".info/connected").observe(.value) { snap in
            let connected = snap.value as? Bool ?? false
            print("connected: \(connected)")
            if !connected {
                return
            }
            let statusRef = database.reference().child(uid)
            
            statusRef.onDisconnectSetValue([
                STATUS: "offline",
                LASTCHANGE: ServerValue.timestamp()
            ]) { (error, _) in
                
                statusRef.setValue([
                    STATUS: "online",
                    LASTCHANGE: ServerValue.timestamp()
                    ])
            }
        }
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


}

