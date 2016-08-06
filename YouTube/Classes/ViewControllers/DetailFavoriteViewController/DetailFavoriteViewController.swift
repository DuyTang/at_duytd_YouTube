//
//  DetailFavoriteViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class DetailFavoriteViewController: BaseViewController {

    @IBOutlet weak var nameListFavoriteLabel: UILabel!
    @IBOutlet weak var listVideoFavoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func configureDetailFavoriteViewController() {
        self.listVideoFavoriteTableView.registerNib(HomeCell)
    }
    // MARK:- Set Up UI
    override func setUpUI() {

    }
    // MARK:- Set Up Data
    override func setUpData() {

    }

    @IBAction func clickBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
//MARK:- UITableViewDataSource
extension DetailFavoriteViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeCell.self)
        cell.configureCell()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.idVideo = "_esoNnEflzM"
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}
//MARK:- UITableViewDelegate
extension DetailFavoriteViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 112
    }
}
