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
private struct Options {
    static let HeightOfCell: CGFloat = 40
}

class AddFavoriteViewController: BaseViewController {
    private var favorites: Results<Favorite>!
    weak var delegate: AddFavoriteDelegate?
    @IBOutlet weak private var addFavoriteView: UIView!
    @IBOutlet weak private var listFavoritePicker: UIPickerView!
    @IBOutlet weak private var addNewListFavoriteView: UIView!
    @IBOutlet weak private var nameNewListFavoriteTextField: UITextField!
    private var idListFavorite = 1
    var video = Video()
    private var myFavorite = Favorite()
    private var isSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Life Cycle
    override func setUp() {
        modalPresentationStyle = .OverCurrentContext
        parentViewController?.modalPresentationStyle = .OverCurrentContext
    }

    override func setUpData() {
        loadData()
    }

    private func loadData() {
        favorites = RealmManager.getAllFavorite()
    }

    // MARK:- Private Function
    private func showSubView(isShow: Bool) {
        addFavoriteView.hidden = !isShow
        addNewListFavoriteView.hidden = isShow
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
            view.removeFromSuperview()
            removeFromParentViewController()
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationDefine.AddVideoFavorite, object: nil, userInfo: ["idFavorite": idListFavorite])
        } else {
            showAlert(Message.Error, message: Message.NoListFavorite, cancelButton: Message.CancelButton)
        }
    }

    @IBAction func backToDetailVideoControllerButton(sender: AnyObject) {
        delegate?.addSuccess(false)
        view.removeFromSuperview()
        removeFromParentViewController()
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
        view.removeFromSuperview()
        removeFromParentViewController()
    }

    @IBAction func backToListFavoriteButton(sender: AnyObject) {
        showSubView(true)
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

