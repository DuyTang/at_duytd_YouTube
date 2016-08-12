//
//  AddFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
protocol AddFavoriteDelegate {
    func addSuccess(isSuccess: Bool)
}

class AddFavoriteViewController: BaseViewController {

    @IBOutlet weak private var addFavoriteView: UIView!
    @IBOutlet weak private var listFavoritePicker: UIPickerView!
    private var dataOfFavorite: Results<Favorite>!
    private var delegate: AddFavoriteDelegate!
    @IBOutlet weak private var addNewListFavoriteView: UIView!
    @IBOutlet weak private var nameNewListFavoriteTextField: UITextField!
    var idVideo = ""
    var idListFavorite = "1"
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
        self.addFavoriteView.setBorder(5.0, borderWidth: 1.0, borderColor: AppDefine.backgroundColor)
        self.addNewListFavoriteView.setBorder(5.0, borderWidth: 1.0, borderColor: AppDefine.backgroundColor)
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
            video = realm.objects(Video).filter("idVideo = %@", idVideo).first!
        } catch {

        }
    }
    // MARK:- Action
    @IBAction func addVideoToFavoriteList(sender: AnyObject) {
        do {
            let realm = try Realm()
            let videoFavorite = VideoFavorite()
            videoFavorite.idVideo = video.idVideo
            videoFavorite.channelTitle = video.channelTitle
            videoFavorite.descript = video.descript
            videoFavorite.idCategory = video.idCategory
            videoFavorite.duration = video.duration
            videoFavorite.viewCount = video.viewCount
            videoFavorite.thumbnail = video.thumbnail
            videoFavorite.title = video.title
            videoFavorite.idListFavorite = idListFavorite
            try realm.write({ () -> Void in
                realm.add(videoFavorite)
            })
        } catch {

        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func clickBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addNewFavoriteList(sender: AnyObject) {
        self.showSubView(false)
    }
    @IBAction func addNameNewFavoriteList(sender: AnyObject) {
        let favorite = Favorite()
        favorite.name = self.nameNewListFavoriteTextField.text!
        favorite.id = String(Favorite.getId() + 1)
        do {
            let realm = try Realm()
            try realm.write({
                realm.add(favorite)
                self.listFavoritePicker.reloadAllComponents()
            })
        } catch {

        }
        self.showSubView(true)
    }

    @IBAction func clickCancel(sender: AnyObject) {
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
        self.idListFavorite = String(dataOfFavorite[row].id)
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

