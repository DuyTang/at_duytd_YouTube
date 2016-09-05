//
//  String.swift
//  YouTube
//
//  Created by Duy Tang on 8/18/16.
//  Copyright © 2016 Duy Tang. All rights reserved.
//
import SwiftUtils

extension String {
    // MARK:- Get time of video
    func convertDuration() -> String {
        var duration = ""
        if checkDurationVideo(self) {
            let formattedDuration = self.stringByReplacingOccurrencesOfString("PT", withString: "").stringByReplacingOccurrencesOfString("H", withString: ":").stringByReplacingOccurrencesOfString("M", withString: ":").stringByReplacingOccurrencesOfString("S", withString: "")
            let components = formattedDuration.componentsSeparatedByString(":")
            for component in components {
                duration = duration.characters.count > 0 ? duration + ":": duration
                if component.characters.count < 2 {
                    duration = component
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
    func checkDurationVideo(text: String) -> Bool {
        let DURATION_REGEX_FULL = "^PT+[0-9]+H[0-9]+M[0-9]+[0-9]S"
        let DURATION_REGEX = "^PT+[0-9]+M[0-9]+[0-9]S"
        let durationTestFull = NSPredicate(format: "SELF MATCHES %@", DURATION_REGEX_FULL)
        let durationTest = NSPredicate(format: "SELF MATCHES %@", DURATION_REGEX)
        let test_REGEX_FULL = durationTestFull.evaluateWithObject(text)
        let test_REGEX = durationTest.evaluateWithObject(text)
        if test_REGEX_FULL || test_REGEX {
            return true
        } else {
            return false
        }
    }
    // MARK:- Get time upload of video
    func getTimeUpload() -> String {
        var time = ""
        if !self.isEmpty {
            let selectedDate = self.toDate(DateFormat.TZDateTime3, localized: false)
            let currentDate = NSDate()
            let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: selectedDate, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
            if diffDateComponents.year != 0 {
                if diffDateComponents.year == 1 {
                    time = "\(diffDateComponents.year) year "
                } else {
                    time = "\(diffDateComponents.year) years"
                }
            } else {
                if diffDateComponents.month != 0 {
                    if diffDateComponents.month == 1 {
                        time = "\(diffDateComponents.month) month"
                    } else {
                        time = "\(diffDateComponents.month) months"
                    }
                } else {
                    if diffDateComponents.day != 0 {
                        if diffDateComponents.day < 7 {
                            if diffDateComponents.day == 1 {
                                time = "\(diffDateComponents.day) day"
                            } else {
                                time = "\(diffDateComponents.day) days"
                            }
                        } else {
                            let week = diffDateComponents.day / 7
                            if week == 1 {
                                time = "\(week) week"

                            } else {
                                time = "\(week) weeks"

                            }
                        }
                    } else {
                        time = " \(diffDateComponents.hour) hours"
                    }
                }
            }
        }
        return time
    }

    // MARK:- Show view count of video
    func getNumberView() -> String {
        var numberView = ""
        let countView = Int(self)
        if self.isEmpty {
            numberView = "0 view"
        } else {
            if countView > 1 {
                if countView > 999999 {
                    numberView = String(countView! / 1000000) + "M views"
                } else {
                    if 999999 >= countView && countView > 999 {
                        numberView = String(countView! / 1000) + "K views"
                    } else {
                        numberView = self + "views"
                    }
                }
            } else {
                numberView = self + " view"
            }
        }
        return numberView
    }

}