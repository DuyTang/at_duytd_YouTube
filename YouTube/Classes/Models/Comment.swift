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
    dynamic var totalReplyCount = ""

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
       topComment <- map["snippet.topLevelComment"]
        totalReplyCount <- map["snippet.totalReplyCount"]
    }
}
