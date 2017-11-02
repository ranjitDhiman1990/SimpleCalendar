//
//  Utilities.swift
//  CalendarDemo
//
//  Created by iOS Dev on 01/11/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import Foundation

class TimeUtility: NSObject {
    
    override init() {
        super.init()
    }
    
    public static func getDateFromString(dateString: String, dateFormat: String) -> Date? {
        let localTimeZoneAbbreviation = TimeZone.current.abbreviation() ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Current time zone
        let date = dateFormatter.date(from: dateString) //according to date format your date string
        
        return date
    }
    
    public static func getStringFromDate(date: Date, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat //Your New Date format as per requirement change it own
        let dateString = dateFormatter.string(from: date) //pass Date here
        return dateString
    }
}
