//
//  AddFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class AddFavoriteViewController: BaseViewController {

    @IBOutlet weak private var addFavoriteView: UIView!
    @IBOutlet weak private var listFavoritePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setAttributeViewController() {
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .OverCurrentContext
        modalTransitionStyle = .CrossDissolve
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        UIView.setBorder(addFavoriteView, cornerRadius: 5.0, borderWidth: 1.0, borderColor: AppDefine.backgroundColor)
        self.setAttributeViewController()
    }
    // MARK:- Set Up Data
    override func setUpData() {

    }
    // MARK:- Set Up
    override func setUp() {
        self.setAttributeViewController()
    }
    // MARK:- Action
    @IBAction func addVideoToFavoriteList(sender: AnyObject) {

    }

    @IBAction func clickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addNewFavoriteList(sender: AnyObject) {
        var inputTextField: UITextField!
        let nameFavoritePrompt = UIAlertController(title: "Enter Name",
            message: "Enter your list", preferredStyle: .Alert)
        nameFavoritePrompt.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        nameFavoritePrompt.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: { (action) -> Void in
            }))
        nameFavoritePrompt.addTextFieldWithConfigurationHandler({ (textField: UITextField!) in
            textField.placeholder = "Name List Favorite"
            inputTextField = textField
            inputTextField.layer.cornerRadius = 4.0
            inputTextField.clipsToBounds = true
        })

        presentViewController(nameFavoritePrompt, animated: true, completion: nil)
    }

}
