//
//  FavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftUtils

class FavoriteViewController: BaseViewController {

    @IBOutlet weak private var favoriteTableView: UITableView!
    private var dataOfFavorite: Results<Favorite>!
    private var listFavorite: Results<Favorite>!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.favoriteTableView.reloadData()
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.navigationController?.navigationBarHidden = true
        self.configureFavoriteController()
    }
    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }
    // MARK:- Configure FavoriteController
    private func configureFavoriteController() {
        self.favoriteTableView.registerNib(FavoriteCell)
    }
    // MARK:- Load Data
    func loadData() {
        do {
            let realm = try Realm()
            dataOfFavorite = realm.objects(Favorite)
        } catch {

        }
    }

}
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favorites = dataOfFavorite {
            return favorites.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.favoriteTableView.dequeue(FavoriteCell)
        let favorite = dataOfFavorite[indexPath.row]
        cell.configureFavoriteCell(favorite)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailFavoriteVC = DetailFavoriteViewController()
        detailFavoriteVC.favorite = dataOfFavorite[indexPath.row]
        self.navigationController?.pushViewController(detailFavoriteVC, animated: true)
    }
}

