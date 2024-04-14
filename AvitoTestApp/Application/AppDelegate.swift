//
//  AppDelegate.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 04.04.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup UserDefaults for FilterVC
        UserDefaults.standard.setValue(true, forKey: "sortByMusic")
        UserDefaults.standard.setValue(false, forKey: "sortByMovies")
        UserDefaults.standard.setValue(true, forKey: "showExplicitContent")
        UserDefaults.standard.setValue(false, forKey: "changeResponseLangToEnglish")
        UserDefaults.standard.setValue(false, forKey: "changeResponseLangToJapan")
        UserDefaults.standard.setValue(true, forKey: "changeResponseLangToRussian")
        UserDefaults.standard.setValue(false, forKey: "showAllResults")
        
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

