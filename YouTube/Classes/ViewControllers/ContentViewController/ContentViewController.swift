//
//  ContentViewController.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class ContentViewController: BaseViewController {

    @IBOutlet weak private var contentTableView: UITableView!
    var pageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func configureContentViewCOntroller() {
        self.contentTableView.registerNib(HomeCell)
    }

    override func setUpUI() {
        configureContentViewCOntroller()
    }
}
extension ContentViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.contentTableView.dequeue(HomeCell)
        cell.configureCell()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVideoVC = DetailVideoViewController()
        detailVideoVC.idVideo = "Y7nkqZvQcBQ"
        self.navigationController?.pushViewController(detailVideoVC, animated: true)
    }
}

extension ContentViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

