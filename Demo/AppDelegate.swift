//
//  AppDelegate.swift
//  Demo
//
//  Created by 林達也 on 2017/06/28.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

struct Song: AppleMusicKit.Song {
    typealias Identifier = String

    let name: String
}
struct Album: AppleMusicKit.Album {
    typealias Identifier = String

    let name: String
}
struct Artist: AppleMusicKit.Artist {
    typealias Identifier = String

    let name: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Session.shared.send(GetSong<Song, Album, Artist>(storefront: "us", id: "203709340")) { (result) in
            print(result)
            switch result {
            case .success(let response):
                print(response?.relationships?.albums.data)
            case .failure(let error):
                print(error)
            }
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
