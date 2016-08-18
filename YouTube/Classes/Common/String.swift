//
//  String.swift
//  YouTube
//
//  Created by Duy Tang on 8/18/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

extension String {

    func getYoutubeFormattedDuration() -> String {
        let formattedDuration = self.stringByReplacingOccurrencesOfString("PT", withString: "").stringByReplacingOccurrencesOfString("H", withString: ":").stringByReplacingOccurrencesOfString("M", withString: ":").stringByReplacingOccurrencesOfString("S", withString: "")
        let components = formattedDuration.componentsSeparatedByString(":")
        var duration = ""
        for component in components {
            duration = duration.characters.count > 0 ? duration + ":": duration
            if component.characters.count < 2 {
                duration += "0" + component
                continue
            }
            duration += component
        }
        return duration
    }

    func getTimeUpload(text: String) -> String {
        var time = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let selectedDate = dateFormatter.dateFromString(text)
        let currentDate = NSDate()
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: selectedDate!, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        if diffDateComponents.year != 0 {
            time = "\(diffDateComponents.year) years, \(diffDateComponents.month) months"
        } else {
            if diffDateComponents.month != 0 {
                if diffDateComponents.day < 7 {
                    time = "\(diffDateComponents.month) months, \(diffDateComponents.day) days"
                } else {
                    let week = diffDateComponents.day / 7
                    time = "\(diffDateComponents.month) months, \(week) weeks"
                }
            } else {
                if diffDateComponents.day != 0 {
                    if diffDateComponents.day < 7 {
                        time = "\(diffDateComponents.day) days, \(diffDateComponents.hour) hours"
                    } else {
                        let week = diffDateComponents.day / 7
                        time = "\(week) weeks, \(diffDateComponents.day % 7 ) days"
                    }
                } else {
                    time = " \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes"
                }
            }
        }
        return time
    }

}