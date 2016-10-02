//
//  VideoService.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import Alamofire

class VideoService {
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

                        if video?.channelId != "" {
                            var parameter = [String: AnyObject]()
                            parameter["part"] = "snippet"
                            parameter["id"] = video?.channelId
                            getChannelThumbnail(parameter, completion: { (response) in
                                video?.idCategory = id
                                video?.channelThumbnail = response as? String ?? ""
                                RealmManager.addRealm(video!)
                                completion(success: true, nextPageToken: pageToken, error: nil)
                            })
                        } else {
                            continue
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
                imageChannel = thumbnail["medium"] as? [String: AnyObject] {
                    if let url = imageChannel["url"] as? String {
                        completion(response: url)
                    } else {
                        completion(response: nil)
                    }
            } else {
                    completion(response: nil)
            }
        }) { (error) in
            completion(response: nil)
        }
    }
}

