//
//  TopComment.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class TopComment: Object, Mappable {
    dynamic var authorDisplayName = ""
    dynamic var authorProfileImageUrl = ""
    dynamic var textDisplay = ""
    dynamic var likeCount = 0
    dynamic var publishedAt = ""

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        authorDisplayName <- map["snippet.authorDisplayName"]
        authorProfileImageUrl <- map["snippet.authorProfileImageUrl"]
        textDisplay <- map["snippet.textDisplay"]
        likeCount <- map["snippet.likeCount"]
        publishedAt <- map["snippet.publishedAt"]
    }
}
