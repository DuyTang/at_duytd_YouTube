//
//  Comment.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Comment: Object, Mappable {
    dynamic var id = ""
    dynamic var topComment: TopComment!
    dynamic var totalReplyCount = 0

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        topComment <- map["snippet.topLevelComment"]
        totalReplyCount <- map["snippet.totalReplyCount"]
    }

    class func loadCommentFromAPI(parameters: [String: AnyObject], completion: APIRequestForResponse) {
        let api = APIDefine.YouTube().getComment()
        APIRequest.GET(api, parameter: parameters, success: { (response) in
            if let data = response as? [String: AnyObject] {
                let pageToken = data["nextPageToken"] as? String
                let items = data["items"] as? NSArray
                var comments = [Comment]()
                for item in items! {
                    let comment = Mapper<Comment>().map(item)
                    comments.append(comment!)
                }
                completion(success: true, response: comments, nextPageToken: pageToken, error: nil)
            }
        }) { (error) in
            completion(success: false, response: nil, nextPageToken: nil, error: error)
        }
    }
}
