//
//  MyVideo.swift
//  YouTube
//
//  Created by Duy Tang on 8/10/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class MyVideo {
    var dataOfVideo: Results<Video>?

    class func loadDataFromAPI(id: String, pageToken: String?, parameters: [String: AnyObject], completion: APIRequestCompletion) {
        let api = APIDefine.YouTube().getListVideo()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                let pageToken = data["nextPageToken"] as? String
                if let items = data["items"] as? NSArray {
                    for item in items {
                        let video = Mapper<Video>().map(item)
                        video?.idCategory = id
                        do {
                            let realm = try Realm()
                            try realm.write({
                                realm.add(video!)
                            })
                        } catch {
                        }
                    }
                }
                completion(success: true, nextPageToken: pageToken, error: nil)
            }
        }) { (error) in
            completion(success: false, nextPageToken: nil, error: error)
        }
    }

}

