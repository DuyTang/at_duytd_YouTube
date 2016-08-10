//
//  AppDelegate.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // init tabbar
        let homeNavi = BaseNavigationController(rootViewController: HomeViewController())
        homeNavi.setAttributeForNavigation(AppDefine.Home, image: AppDefine.ImageHome)

        let favoriteNavi = BaseNavigationController(rootViewController: FavoriteViewController())
        favoriteNavi.viewControllers = [FavoriteViewController()]
        favoriteNavi.setAttributeForNavigation(AppDefine.Favorite, image: AppDefine.ImageFavorite)

        let historyNavi = BaseNavigationController(rootViewController: HistoryViewController())
        historyNavi.viewControllers = [HistoryViewController()]
        historyNavi.setAttributeForNavigation(AppDefine.History, image: AppDefine.ImageHistory)

        let tabbar = BaseTabbarViewController()
        tabbar.viewControllers = [favoriteNavi, homeNavi, historyNavi]
        tabbar.selectedIndex = 1

        self.window?.rootViewController = tabbar
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

}

