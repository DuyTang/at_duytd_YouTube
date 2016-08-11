//
//  Category.swift
//  YouTube
//
//  Created by Duy Tang on 8/10/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Category: Object, Mappable {
    dynamic var id = ""
    dynamic var title = ""

    required convenience init(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        var snippet = [String: AnyObject]()
        snippet <- map["snippet"]
        title = (snippet["title"] as? String)! ?? ""
    }

    class func getCategories() -> Results<Category>? {
        do {
            let realm = try Realm()
            let categories = realm.objects(self)
            return categories
        } catch {
            return nil
        }
    }

    class func cleanData() {
        do {
            let realm = try Realm()
            let categories = realm.objects(self)
            try realm.write({
                realm.delete(categories)
            })
        } catch {

        }
    }
}
