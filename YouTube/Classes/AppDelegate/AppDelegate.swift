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
    var tabBarController: CustomTabBarController?
    var thumbnailView: UIView?
    var videoDetailVC = DetailVideoViewController()
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        thumbnailView = UIView(frame: CGRect(x: width - 140, y: height - 140, width: 140, height: 80))

        // init tabbar
        let homeNavi = BaseNavigationController(rootViewController: HomeViewController())
        homeNavi.setAttributeForNavigation(Tabbar.Home, image: Tabbar.ImageHome)

        let favoriteNavi = BaseNavigationController(rootViewController: FavoriteViewController())
        favoriteNavi.setAttributeForNavigation(Tabbar.Favorite, image: Tabbar.ImageFavorite)

        let historyNavi = BaseNavigationController(rootViewController: HistoryViewController())
        historyNavi.setAttributeForNavigation(Tabbar.History, image: Tabbar.ImageHistory)

        let trendingNavi = BaseNavigationController(rootViewController: TrendingViewController())
        trendingNavi.setAttributeForNavigation(Tabbar.Trending, image: Tabbar.ImageTrending)

        tabBarController = CustomTabBarController()
        tabBarController?.viewControllers = [homeNavi, trendingNavi, favoriteNavi, historyNavi]
        tabBarController?.selectedIndex = 0

        self.window?.rootViewController = tabBarController
        thumbnailView?.clipsToBounds = true
        window?.rootViewController!.view.addSubview(thumbnailView!)

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

