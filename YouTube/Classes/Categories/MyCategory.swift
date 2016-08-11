//
//  MyCategory.swift
//  YouTube
//
//  Created by Duy Tang on 8/10/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import ObjectMapper

class MyCategory {
    var dataOfCategory: Results<Category>!
    class func getVideoCatetogories(parameters: [String: AnyObject], completion: APIRequestCompletion) {
        let api = APIDefine.YouTube().getListCategory()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                if let items = data["items"] as? NSArray {
                    Category.cleanData()
                    Video.cleanData()
                    for item in items {
                        let category = Mapper<Category>().map(item)
                        do {
                            let realm = try Realm()
                            try realm.write({ () -> Void in
                                realm.add(category!)
                            })
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            completion(success: true, nextPageToken: nil, error: nil)

        }) { (error) in
            completion(success: false, nextPageToken: nil, error: error)
        }

    }
}

