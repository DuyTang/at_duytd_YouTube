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
        // func getListVideoFromIdCategory() -> String {
        // return "https://www.googleapis.com/youtube/v3/videos?part=snippet&maxResults=10&" +
        // "key=AIzaSyCH3W03eJCg52RIGnfvCjgTfs21Tddl6Io&videoCategoryId=" +
        // IdCategory + "&chart=mostPopular"
        // }
        //
        // // API List Video From Name
        // func getListVideoFromName() -> String {
        // return "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=" +
        // NameVideo + "&key=AIzaSyCH3W03eJCg52RIGnfvCjgTfs21Tddl6Io"
        // }

    }

}
