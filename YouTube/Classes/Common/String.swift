//
//  String.swift
//  YouTube
//
//  Created by Duy Tang on 8/18/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//

extension String {
    // MARK:- Get time of video
    func getYoutubeFormattedDuration() -> String {
        var duration = ""
        if isValidDuration(self) == true {
            let formattedDuration = self.stringByReplacingOccurrencesOfString("PT", withString: "").stringByReplacingOccurrencesOfString("H", withString: ":").stringByReplacingOccurrencesOfString("M", withString: ":").stringByReplacingOccurrencesOfString("S", withString: "")
            let components = formattedDuration.componentsSeparatedByString(":")
            for component in components {
                duration = duration.characters.count > 0 ? duration + ":": duration
                if component.characters.count < 2 {
                    duration += "0" + component
                    continue
                }
                duration += component
            }

        } else {
            duration = "-:-"
        }
        return duration
    }
    // MARK:- Validate time of Video
    func isValidDuration(text: String) -> Bool {
        let DURATION_REGEX = "^PT+[1-9]+H[1-9]+M[1-9]+[1-9]S"
        let DURATION_REGEX1 = "^PT+[1-9]+M[1-9]+[1-9]S"
        let durationTest = NSPredicate(format: "SELF MATCHES %@", DURATION_REGEX)
        let durationTest1 = NSPredicate(format: "SELF MATCHES %@", DURATION_REGEX1)
        let result = durationTest.evaluateWithObject(text)
        let result1 = durationTest1.evaluateWithObject(text)
        if result == true || result1 == true {
            return true
        } else {
            return false
        }
    }
    // MARK:- Get time upload of video
    func getTimeUpload(text: String) -> String {
        var time = ""
        if isValidDateTime(text) == true {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let selectedDate = dateFormatter.dateFromString(text)
            let currentDate = NSDate()
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: selectedDate!, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
            if diffDateComponents.year != 0 {
                time = "\(diffDateComponents.year) years"
            } else {
                if diffDateComponents.month != 0 {
                    time = "\(diffDateComponents.month) months"
                } else {
                    if diffDateComponents.day != 0 {
                        if diffDateComponents.day < 7 {
                            time = "\(diffDateComponents.day) days"
                        } else {
                            let week = diffDateComponents.day / 7
                            time = "\(week) weeks"
                        }
                    } else {
                        time = " \(diffDateComponents.hour) hours"
                    }
                }
            }
        }
        return time
    }
    // MARK:- Validate time upload
    func isValidDateTime(text: String) -> Bool {
        let DATETIME_REGEX = "^[0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+.000Z"
        let durationTest = NSPredicate(format: "SELF MATCHES %@", DATETIME_REGEX)
        let result = durationTest.evaluateWithObject(text)
        return result
    }
    // MARK:- Show view count of video
    func getNumberView() -> String {
        var numberView = ""
        let countView = Int(self)
        if self == "" {
            numberView = "0 view"
        } else {
            if countView > 999999 {
                numberView = String(countView! / 1000000) + "M views"
            } else {
                if countView > 999 {
                    numberView = String(countView! / 1000) + "K views"
                } else {
                    numberView = self + "views"
                }
            }
        }
        return numberView
    }

}