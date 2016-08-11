//
//  AddFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class AddFavoriteViewController: BaseViewController {

    @IBOutlet weak private var addFavoriteView: UIView!
    @IBOutlet weak private var listFavoritePicker: UIPickerView!
    var idVideo = ""
    var idListFavorite = "1"
    var dataOfFavorite: Results<Favorite>!
    var video = Video()
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
        loadData()
    }
    // MARK:- Set Up
    override func setUp() {
        self.setAttributeViewController()
    }
    // MARK:- Load Data
    private func loadData() {
        do {
            let realm = try Realm()
            dataOfFavorite = realm.objects(Favorite)
            video = realm.objects(Video).filter("idVideo = '\(idVideo)'").first!
        } catch {

        }
    }
    // MARK:- Action
    @IBAction func addVideoToFavoriteList(sender: AnyObject) {
        do {
            let realm = try Realm()
            let favorite = realm.objects(Favorite).filter("id = '\(idListFavorite)'").first!
            try realm.write({
                video.idListFavorite = idListFavorite
                video.isFavorite = true
                favorite.numberVideo = favorite.numberVideo + 1
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        } catch {

        }
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
            let textfield = nameFavoritePrompt.textFields![0]
            let favorite = Favorite()
            favorite.name = textfield.text!
            favorite.id = String(Favorite.getId() + 1)
            favorite.numberVideo = 0
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(favorite)
                    self.listFavoritePicker.reloadAllComponents()
                })
            } catch {

            }
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
extension AddFavoriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let favorites = dataOfFavorite {
            return favorites.count
        } else {
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataOfFavorite[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.idListFavorite = dataOfFavorite[row].id
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

