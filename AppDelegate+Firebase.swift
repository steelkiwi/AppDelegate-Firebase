//
//  AppDelegate+Firebase.swift
//  
//
//  Created by Viktor Olesenko on 03.03.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UserNotifications
import Firebase

extension AppDelegate {
    
    typealias PushNotification = [AnyHashable : Any]
    
    internal func initNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard granted else { return }
                
                self.getNotificationSettings()
            }
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configureIfNeeded()
        Messaging.messaging().delegate = self
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
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

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // TODO: Store token
    }
}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        openNotification(userData: userInfo)
        
        let displayOptions: UNNotificationPresentationOptions = [] // badge, alert, sound
        
        completionHandler(displayOptions)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        openNotification(userData: userInfo)
        
        completionHandler()
    }
}

extension FirebaseApp {
    
    static var isConfigured: Bool {
        return FirebaseApp.app() != nil
    }
    
    static func configureIfNeeded() {
        guard isConfigured == false else { return }
        
        configure()
    }
}
