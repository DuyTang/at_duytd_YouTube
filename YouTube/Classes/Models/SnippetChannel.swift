//
//  SnippetChannel.swift
//  YouTube
//
//  Created by Duy Tang on 9/12/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class SnippetChannel: Object, Mappable {
    dynamic var title = ""
    dynamic var descript = ""
    dynamic var publishedAt = ""
    dynamic var thumbnails = ""

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        title <- map["title"]
        descript <- map["description"]
        publishedAt <- map["publishedAt"]
        thumbnails <- map["thumbnails.medium.url"]
    }
}
