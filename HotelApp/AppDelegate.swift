//
//  AppDelegate.swift
//  HotelApp
//
//  Created by Konstantinos Loutas on 10/07/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setting up for Notifications
        application.applicationIconBadgeNumber = 0
        registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        handleApplicationLaunchByNotification(appLaunchOptions: launchOptions)
        
        // Request permission to use location services
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Starts the generation of updates that report the user’s current location.
            simpleAlert(title: "Authorised", message: "\(status) authorisation granted")
            locationManager.startUpdatingLocation()
            
        case .restricted:
            // Your app is not authorized to use location services.
            simpleAlert(title: "Permission Error", message: "Need Location Service Permission To Access Beacon")
            
            
        case .denied:
            // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.
            simpleAlert(title: "Permission Error", message: "Need Location Service Permission To Access Beacon")
            
        default:
            // handle .NotDetermined here
            // The user has not yet made a choice regarding whether this app can use location services.
            break
        }
    }
    
}

// MARK: - Simple alerting
extension AppDelegate {
    func simpleAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        print("\(title): \(message)")
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Registering for Push Notifications
extension AppDelegate {
    
    func registerForRemoteNotifications() {
        // Registering Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in /*...*/ }
        // Token registration for remote notifications
        UIApplication.shared.registerForRemoteNotifications()
        // Get user notification settings
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in /*...*/ }
    }
    
    // MARK: Getting device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print("Device token: \(deviceTokenString)")
    }
    
    // Handling errors while registering for remote notification
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for Remote Notifications: \(error.localizedDescription)")
    }
    
}

// MARK: - Handling notifications
extension AppDelegate: UNUserNotificationCenterDelegate {

    // When app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
        
        let notificationDate = notification.date
        let notificationBody = notification.request.content.body
        let notificationDictionary = notification.request.content.userInfo
        
        print("Notification date: \(notificationDate)")
        print("Notification content body: \(notificationBody)")
        print("Notification content dictionary: \(notificationDictionary)")
    }
    
    // MARK: - Handle Application Launching through a Notification
    func handleApplicationLaunchByNotification(appLaunchOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            print("App launched via a notification")
            print(notification)
        }
    }

}
