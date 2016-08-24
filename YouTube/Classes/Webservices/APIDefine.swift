//
//  APIDefine.swift
//  YouTube
//
//  Created by Duy Tang on 8/6/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

import Foundation

class APIDefine {

    static let EndPoint = "https://www.googleapis.com/youtube/v3"

    struct YouTube {

        // API List Video Category
        func getListCategory() -> String {
            return EndPoint + "/videoCategories"

        }

        // API List Video From Id Video Category
        func getListVideo() -> String {
            return EndPoint + "/videos"
        }
        // API List Video Related
        func getListVideoRelated() -> String {
            return EndPoint + "/search"
        }

        func getResultAutoCompleteSearch() -> String {
            return "https://suggestqueries.google.com/complete/search?client=youtube&ds=yt&client=firefox"
        }
    }

}
