//
//  FavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {

    @IBOutlet weak private var favoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- Configure FavoriteController
    private func configureFavoriteController() {
        self.favoriteTableView.registerNib(FavoriteCell)
    }

    // MARK:- Set Up UI
    override func setUpUI() {
        configureFavoriteController()
    }
    // MARK:- Set Up Data
    override func setUpData() {

    }

}
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.favoriteTableView.dequeue(FavoriteCell)
        cell.configureFavoriteCell()
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailFavoriteVC = DetailFavoriteViewController()
        self.navigationController?.pushViewController(detailFavoriteVC, animated: true)
    }
}

