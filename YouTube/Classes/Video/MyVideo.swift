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
import Alamofire

class MyVideo {
    var dataOfVideo: Results<Video>?
    static var searchRequest: Alamofire.Request?
    class func loadDataFromAPI(id: String, parameters: [String: AnyObject], completion: APIRequestCompletion) {
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

    class func loadListVideoRelated(parameters: [String: AnyObject], completion: APIRequestSuccess) {
        let api = APIDefine.YouTube().getListVideoRelated()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                let items = data["items"] as? NSArray
                completion(response: items)
            }
        }) { (error) in
            completion(response: nil)
        }
    }
    class func loadDetailVideoFromIdVideo(parameters: [String: AnyObject], completion: APIRequestSuccess) {
        let api = APIDefine.YouTube().getListVideo()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                let items = data["items"] as? NSArray
                completion(response: items)
            }
        }) { (error) in
            completion(response: nil)
        }
    }

    class func searchVideoForKey(parameters: [String: AnyObject], completion: APIRequestForResponse) {
        let api = APIDefine.YouTube().getListVideoRelated()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                let pageToken = data["nextPageToken"] as? String
                let items = data["items"] as? NSArray
                completion(success: true, response: items, nextPageToken: pageToken, error: nil)
            }
        }) { (error) in
            completion(success: false, response: nil, nextPageToken: nil, error: error)
        }
    }

    class func searchKey(parameters: [String: AnyObject], completion: APIRequestSuccess) {
        let api = APIDefine.YouTube().getResultAutoCompleteSearch()
        searchRequest?.cancel()
        searchRequest = Alamofire.request(.GET, api, parameters: parameters)
            .validate()
            .responseString { response in
                completion(response: response.result.value)
        }
    }

    class func getChannelThumbnail(parameters: [String: AnyObject], completion: APIRequestSuccess) {
        let api = APIDefine.YouTube().getChannel()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject], items = data["items"] as? NSArray,
                item = items[0] as? [String: AnyObject],
                snippet = item["snippet"] as? [String: AnyObject],
                thumbnail = snippet["thumbnails"] as? [String: AnyObject],
                imageChannel = thumbnail["high"] as? [String: AnyObject] {
                    if let url = imageChannel["url"] as? String {
                        completion(response: url)
                    }
            }
        }) { (error) in
            completion(response: nil)
        }
    }
}

