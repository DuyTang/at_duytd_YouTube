//
//  AppDelegate.swift
//  RealmNotication
//
//  Created by Duy Tang on 8/1/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigation: UINavigationController?
    var tabbar: UITabBarController?
    class func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if self.window != nil {
            // init navigation
            // init tabbar
            let homeNavi = UINavigationController()
            let homeVC = HomeViewController()
            // navigation = UINavigationController(rootViewController: homeVC)
            homeNavi.viewControllers = [homeVC]
            setAttributeForNavigation(homeNavi, title: "Home", image: "Home-30", selectedImage: "Home")

            let favoriteNavi = UINavigationController()
            // let favariteVC = FavariteViewController()
            // favoriteNavi.viewControllers = [favariteVC]
            // setAttributeForNavigation(favoriteNavi, title: "Favorite", image: "Christmas Star-30", selectedImage: "Star")

            let mapNavi = UINavigationController()
            // let mapVC = MapViewController()
            // mapNavi.viewControllers = [mapVC]
            // setAttributeForNavigation(mapNavi, title: "Map", image: "Map Marker-30", selectedImage: "Map")

            tabbar = UITabBarController()
            self.tabbar?.viewControllers = [homeNavi, favoriteNavi, mapNavi]
            self.tabbar!.tabBar.barTintColor = UIColor.whiteColor()
            self.tabbar!.tabBar.tintColor = UIColor.blueColor()
            self.window?.rootViewController = tabbar
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    func setAttributeForNavigation(navi: UINavigationController, title: String, image: String, selectedImage: String) {
        navi.title = title
        navi.tabBarItem.image = UIImage(named: image)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navi.tabBarItem.selectedImage = UIImage(named: selectedImage)!.imageWithRenderingMode(.AlwaysTemplate)
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

