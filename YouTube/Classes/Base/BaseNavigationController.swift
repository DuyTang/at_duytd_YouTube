//
//  BaseNavigationController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        view.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor.whiteColor()
        navigationBar.translucent = false
        navigationBar.hidden = true
        navigationBar.shadowImage = UIImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func setAttributeForNavigation(title: String, image: String) {
        self.title = title
        tabBarItem.image = UIImage(named: image)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //tabBarItem.selectedImage = UIImage(named: image)!.imageWithRenderingMode(.AlwaysTemplate)
    }

}
