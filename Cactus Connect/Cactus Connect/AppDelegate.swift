//
//  AppDelegate.swift
//  Cactus Connect
//
//  Created by Admin on 2/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Checking streak
        UserDefaults.standard.register(defaults: [streakKey : 0, lastUsedTimeKey: 0])
        let currentDateTimeInterval = Int(Date().timeIntervalSinceReferenceDate)
        var currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        let lastDateTimeInterval = UserDefaults.standard.integer(forKey: lastUsedTimeKey)
        
        let difference = currentDateTimeInterval - lastDateTimeInterval
        if (difference > 86400) && (difference < 172800) { // Between 1 and 2 days -- user opened app next day
            currentStreak = currentStreak + 1
            UserDefaults.standard.set(currentStreak, forKey: streakKey)
        } else if difference > 86400 { // Greater than one day -- user didn't open app the next day
            currentStreak = currentStreak - 1
            UserDefaults.standard.set(currentStreak, forKey: streakKey)
        } /*else if (difference > 60) && (difference < 120) { // Between 1 and 2 minutes
            currentStreak = currentStreak + 1
            UserDefaults.standard.set(currentStreak, forKey: streakKey)
        }*/
        
        UserDefaults.standard.set(currentDateTimeInterval, forKey: lastUsedTimeKey)
        
        return true
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

