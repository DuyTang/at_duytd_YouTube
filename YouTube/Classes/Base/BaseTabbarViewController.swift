//
//  BaseTabbarViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class BaseTabbarViewController: UITabBarController {
    var arrayNavigationControllers = [BaseNavigationController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = AppDefine.backgroundColor
        self.tabBar.tintColor = AppDefine.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
