//
//  HomeViewController.swift
//  RealmNotication
//
//  Created by Duy Tang on 8/1/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let api = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=Anh+cu+di+di&key=AIzaSyCH3W03eJCg52RIGnfvCjgTfs21Tddl6Io"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "HOME"
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"), style: .Done, target: self, action: #selector(search))
        self.navigationItem.rightBarButtonItem = searchButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search() {
        
    }

}
