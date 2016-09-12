//
//  Channel.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Channel: Object, Mappable {
    dynamic var id = ""
    dynamic var snippet: SnippetChannel!
    dynamic var viewCount = ""
    dynamic var subscriberCount = ""
    dynamic var videoCount = ""

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        snippet <- map["snippet"]
        viewCount <- map["statistics.viewCount"]
        subscriberCount <- map["statistics.subscriberCount"]
        videoCount <- map["statistics.videoCount"]
    }

}