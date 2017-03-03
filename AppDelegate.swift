//
//  AppDelegate.swift
//
//
//  Created by Viktor Olesenko on 03.03.17.
//  Copyright © 2017 Viktor Olesenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        initNotifications(application: application, mode: .sandbox) // unknown, sandbox, prod
        
        return true
    }
    
    // MARK: - Push Notifications
    
    internal func openNotification(userData: PushNotification) {
        
        // open push notifications only from bg state
        guard application.applicationState != .active else {
            return
        }
        
        // Push handling here
    }

}

