//
//  AppDelegate.swift
//  background-test
//
//  Created by Rustam  on 1/12/20.
//  Copyright © 2020 Rustam . All rights reserved.
//

import UIKit
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.setMinimumBackgroundFetchInterval(3600) //telling a system to wake up every hour
        
        return true
    }
    //MARK: - Background fetch request
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let data = request() {
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
    
    //MARK: - Silent push notification handling
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //
        // handling push notification payload
        //
        if let data = request() {
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
        
    func request() -> Data? {
        
        var receiveData: Data?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = Date()
        let dateStr = dateFormatter.string(from: date)
        
        Network.shared.sendData(date: dateStr) { (status, code, data) in
            if status {
                receiveData = data
            } else {
                receiveData = nil
            }
        }
        return receiveData
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    


}

