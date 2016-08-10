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

    class func loadDataFromAPI(completion: APIRequestCompletion, id: String, pageToken: String) {
        let api = APIDefine.YouTube().getListVideo()
        var parameters = [String: AnyObject]()
        parameters["part"] = "snippet,contentDetails,statistics"
        parameters["maxResults"] = "10"
        parameters["chart"] = "mostPopular"
        parameters["videoCategoryId"] = id
        parameters["regionCode"] = "VN"
        parameters["pageToken"] = ""
        Video.cleanData()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
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
            }
            completion(success: true, error: nil)
        }) { (error) in
            completion(success: false, error: error)
        }
    }
    class func getNumberView(completion: APIRequestCompletion, id: String) {
        let api = APIDefine.YouTube().getListVideo()
        var parameters = [String: AnyObject]()
        parameters["part"] = "statistics"
        parameters["id"] = id
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            completion(success: true, error: nil)
        }) { (error) in
            completion(success: false, error: error)
        }

    }

}

