//
//  CategoryService.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import ObjectMapper

class CategoryService {
    class func getVideoCatetogories(parameters: [String: AnyObject], completion: APIRequestCompletion) {
        let api = APIDefine.YouTube().getListCategory()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                if let items = data["items"] as? NSArray {
                    for item in items {
                        let category = Mapper<Category>().map(item)
                        if category!.id == "18" || category!.id == "21" {
                            // category no data
                            continue
                        } else {
                            do {
                                let realm = try Realm()
                                try realm.write({ () -> Void in
                                    realm.add(category!)
                                })
                            } catch {
                            }
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

