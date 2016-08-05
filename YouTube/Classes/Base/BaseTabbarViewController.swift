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
        self.tabBar.barTintColor = UIColor.init(hex: AppDefine.backgroundColor)
        self.tabBar.tintColor = UIColor.init(hex: AppDefine.mainColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
