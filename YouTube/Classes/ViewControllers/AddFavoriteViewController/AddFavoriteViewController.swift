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
    var myFavorite = Favorite()
    var isSaved = false

    private struct Options {
        static let HeightOfCell: CGFloat = 40
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        modalPresentationStyle = .OverCurrentContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setAttributeViewController() {
        modalPresentationStyle = .OverCurrentContext
        parentViewController?.modalPresentationStyle = .OverCurrentContext

    }

    // MARK:- Set Up UI
    override func setUpUI() {
    }

    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }

    // MARK:- Set Up
    override func setUp() {
        setAttributeViewController()
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
                myFavorite = realm.objects(Favorite).filter("id = %@", idListFavorite).first!
                try realm.write({ () -> Void in
                    myFavorite.listVideo.append(videoFavorite)
                    self.isSaved = true
                })
            } catch {

            }
            delegate?.addSuccess(isSaved)
            dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationDefine.AddVideoFavorite, object: nil, userInfo: ["idFavorite": idListFavorite])
        } else {
            showAlert(Message.Error, message: Message.NoListFavorite, cancelButton: Message.CancelButton)
        }
    }

    @IBAction func backToDetailVideoControllerButton(sender: AnyObject) {
        delegate?.addSuccess(false)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    @IBAction func showAddNameFavoriteListViewButton(sender: AnyObject) {
        showSubView(false)
    }

    @IBAction func addNewFavoriteListButton(sender: AnyObject) {
        if nameNewListFavoriteTextField.text! != "" {
            let favorite = Favorite()
            favorite.name = nameNewListFavoriteTextField.text!
            favorite.id = Favorite.getId() + 1
            do {
                let realm = try Realm()
                let videoFavorite = VideoFavorite()
                videoFavorite.initializate(video, idListFavorite: favorite.id)
                try realm.write({
                    realm.add(favorite)
                    favorite.listVideo.append(videoFavorite)
                    self.delegate?.addSuccess(true)
                })
            } catch {

            }
        }
        idListFavorite = Favorite.getId()
//        dismissViewControllerAnimated(true, completion: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }

    @IBAction func backToListFavoriteButton(sender: AnyObject) {
        showSubView(true)
    }

    private func showSubView(isShow: Bool) {
        addFavoriteView.hidden = !isShow
        addNewListFavoriteView.hidden = isShow
    }
}

//MARK:- Extension UIPickerView
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
        idListFavorite = favorites[row].id
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Options.HeightOfCell
    }
}

