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
        homeNavi.setAttributeForNavigation(Tabbar.Home, image: Tabbar.ImageHome)

        let favoriteNavi = BaseNavigationController(rootViewController: FavoriteViewController())
        favoriteNavi.setAttributeForNavigation(Tabbar.Favorite, image: Tabbar.ImageFavorite)

        let historyNavi = BaseNavigationController(rootViewController: HistoryViewController())
        historyNavi.setAttributeForNavigation(Tabbar.History, image: Tabbar.ImageHistory)

        let trendingNavi = BaseNavigationController(rootViewController: TrendingViewController())
        trendingNavi.setAttributeForNavigation(Tabbar.Trending, image: Tabbar.ImageTrending)

        let tabbar = BaseTabbarViewController()
        tabbar.viewControllers = [favoriteNavi, homeNavi, trendingNavi, historyNavi]
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

