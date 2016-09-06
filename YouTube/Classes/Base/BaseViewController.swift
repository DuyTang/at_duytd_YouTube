//
//  BaseViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD
import RealmS

protocol BaseViewControllerProtocol: class {
    func baseViewControllerGetName(isCardHomeVC: Bool)
}

class BaseViewController: UIViewController {

    // MARK: - Init

    init() {
        let className = NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last
        if let _ = NSBundle.mainBundle().pathForResource(className, ofType: "nib") {
            super.init(nibName: className, bundle: nil)
        } else {
            super.init()
        }
        setUp()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
        self.setUpUI()

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        hideLoading()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    // MARK: - Setup
    func setUp() {

    }

    func setUpUI() {

    }

    func setUpData() {
    }
    // MARK: - Hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - Navigation Controller

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func close() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Progress

    func showAlert(title: String?, message mes: String?, cancelButton cancel: String) {
        let alertController = UIAlertController(title: title, message: mes, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            }))
        presentViewController(alertController, animated: true, completion: nil)

    }

    func openSafari(url: String) {
        if url != "" {
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
    }

    private func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass)
    }
}

extension UIViewController {
    static func instanceWithDefaultNib() -> Self? {
        if let strClass = self as? AnyClass {
            let className = NSStringFromClass(strClass).componentsSeparatedByString(".").last
            let bundle = NSBundle(forClass: strClass)
            return self.init(nibName: className, bundle: bundle)
        }

        return nil
    }

    func showLoading() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    }

    func hideLoading() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }
    }
}
