//
//  AddFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
protocol AddFavoriteDelegate: NSObjectProtocol {
    func addSuccess(isSuccess: Bool)
}

class AddFavoriteViewController: BaseViewController {

    @IBOutlet weak private var addFavoriteView: UIView!
    @IBOutlet weak private var listFavoritePicker: UIPickerView!
    private var favorites: Results<Favorite>!
    weak var delegate: AddFavoriteDelegate?
    @IBOutlet weak private var addNewListFavoriteView: UIView!
    @IBOutlet weak private var nameNewListFavoriteTextField: UITextField!
    var idListFavorite = 1
    var video = Video()
    var isSaved = false
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
        self.addFavoriteView.setBorder(5.0, borderWidth: 1.0, borderColor: UIColors.BackgroundColor)
        self.addNewListFavoriteView.setBorder(5.0, borderWidth: 1.0, borderColor: UIColors.BackgroundColor)
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
            favorites = realm.objects(Favorite)
        } catch {

        }
    }
    // MARK:- Action
    @IBAction func addFavoriteButton(sender: AnyObject) {
        if favorites.count > 0 {
            do {
                let realm = try Realm()
                let videoFavorite = VideoFavorite()
                videoFavorite.initializate(video, idListFavorite: idListFavorite)
                try realm.write({ () -> Void in
                    realm.add(videoFavorite)
                    self.isSaved = true
                })
            } catch {

            }
            self.delegate?.addSuccess(isSaved)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.showAlert(AppDefine.Error, message: AppDefine.NoListFavorite, cancelButton: AppDefine.CancelButton)
        }
    }

    @IBAction func backToDetailVideoControllerButton(sender: AnyObject) {
        self.delegate?.addSuccess(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func showAddNameFavoriteListViewButton(sender: AnyObject) {
        self.showSubView(false)
    }
    @IBAction func addNewFavoriteListButton(sender: AnyObject) {
        if self.nameNewListFavoriteTextField.text! != "" {
            let favorite = Favorite()
            favorite.name = self.nameNewListFavoriteTextField.text!
            favorite.id = Favorite.getId() + 1
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(favorite)
                    self.listFavoritePicker.reloadAllComponents()
                })
            } catch {

            }
            self.showSubView(true)
            self.listFavoritePicker.selectRow(favorite.id - 1, inComponent: 0, animated: true)
        }
        idListFavorite = Favorite.getId()
    }

    @IBAction func backToListFavoriteButton(sender: AnyObject) {
        self.showSubView(true)
    }
    private func showSubView(isShow: Bool) {
        self.addFavoriteView.hidden = !isShow
        self.addNewListFavoriteView.hidden = isShow
    }
}
extension AddFavoriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let favorites = favorites {
            return favorites.count
        } else {
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return favorites[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.idListFavorite = favorites[row].id
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

