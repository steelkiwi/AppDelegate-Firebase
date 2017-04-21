//
//  AppDelegate+Firebase.swift
//  
//
//  Created by Viktor Olesenko on 03.03.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UserNotifications
import Firebase

private var pushMode: FIRInstanceIDAPNSTokenType = .unknown

extension AppDelegate {
    
    typealias PushNotification = [AnyHashable : Any]
    
    internal func initNotifications(application: UIApplication, mode: FIRInstanceIDAPNSTokenType) {
        
        pushMode = mode
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (_, _) in })
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: .firInstanceIDTokenRefresh, object: nil)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            #if DEBUG
                print("InstanceID token: \(refreshedToken)")
            #endif
        }
        
        connectToFcm()
    }
    
    func connectToFcm() {
        guard FIRInstanceID.instanceID().token() != nil else { return }
        
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect(completion: { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        })
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: pushMode)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // If not simulator
        if error.code != 3010 {
            print("APNS ERROR: " + error.localizedDescription)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        openNotification(userData: userInfo)
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        openNotification(userData: userInfo)
        
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        openNotification(userData: userInfo)
        
        completionHandler()
    }
}
