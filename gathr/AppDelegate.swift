//
//  AppDelegate.swift
//  gathr
//
//  Created by Gates Zeng on 2/28/17.
//  Copyright © 2017 Gates Zeng. All rights reserved.
//

import UIKit
import Parse
import UserNotifications
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor(red: 205/255, green: 80/255, blue: 0, alpha: 1.0)
        
        // Prevent keyboard from covering textfields
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

        // For user notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        // Parse API key
        Parse.initialize(with: ParseClientConfiguration(block: {(configuration: ParseMutableClientConfiguration) in
            configuration.applicationId = "projectx"
            configuration.clientKey = "asdbu09gj092q4g0fdfnni&*&Y(*@#ibi2uubr9u2h98&"
            configuration.server = "https://danksquad-gathr.herokuapp.com/parse"
        }))        
        
        // Google Places API key
        GMSPlacesClient.provideAPIKey("AIzaSyCNXlpUPWqc-v6-kLqmKzx-_gTMGGkWSIA")
        GMSServices.provideAPIKey("AIzaSyCNXlpUPWqc-v6-kLqmKzx-_gTMGGkWSIA")
        
        // A user is logged in
        if PFUser.current() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "homeScreen")
            window?.rootViewController = vc
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

