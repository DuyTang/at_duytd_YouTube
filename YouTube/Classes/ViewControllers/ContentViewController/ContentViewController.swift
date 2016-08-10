//
//  ContentViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift

class ContentViewController: BaseViewController {

    @IBOutlet weak private var contentTableView: UITableView!
    var pageIndex = 0
    var pageId = "1"
    private var dataOfVideo: Results<Video>?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    // MARK:- Set Up UI
    override func setUpUI() {
        self.configureContentViewCOntroller()
    }
    // MARK:- Set Up Data
    override func setUpData() {
        loadData()
    }
    // MARK:- Register Cell
    private func configureContentViewCOntroller() {
        self.contentTableView.registerNib(HomeCell)
    }
    // MARK:- Load Data
    func loadData() {
        do {
            let realm = try Realm()
            dataOfVideo = realm.objects(Video).filter("idCategory = '\(pageId)'")
            self.contentTableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
//MARK:- UITableViewDataSource
extension ContentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataOfVideo?.count)!
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.contentTableView.dequeue(HomeCell)
        let video = self.dataOfVideo![indexPath.row]
        cell.configureCell(video)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.video = dataOfVideo![indexPath.row]
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}
//MARK:- UITableViewDelegate
extension ContentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

