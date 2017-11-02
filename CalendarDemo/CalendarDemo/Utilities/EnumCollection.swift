//
//  EnumCollection.swift
//  CalendarDemo
//
//  Created by iOS Dev on 01/11/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import Foundation


public enum Month {
    case Jan
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec
    
    public func description() -> String {
        switch self {
        case .Jan:
            return "Jan"
        case .Feb:
            return "Feb"
        case .Mar:
            return "Mar"
        case .Apr:
            return "Apr"
        case .May:
            return "May"
        case .Jun:
            return "Jun"
        case .Jul:
            return "Jul"
        case .Aug:
            return "Aug"
        case .Sep:
            return "Sep"
        case .Oct:
            return "Oct"
        case .Nov:
            return "Nov"
        case .Dec:
            return "Dec"
        }
    }
    
    public func monthIndex() -> Int {
        switch self {
        case .Jan:
            return 01
        case .Feb:
            return 02
        case .Mar:
            return 03
        case .Apr:
            return 04
        case .May:
            return 05
        case .Jun:
            return 06
        case .Jul:
            return 07
        case .Aug:
            return 08
        case .Sep:
            return 09
        case .Oct:
            return 10
        case .Nov:
            return 11
        case .Dec:
            return 12
        }
    }
}


public enum Week {
    case Sun
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    
    
    public func description() -> String {
        switch self {
        case .Sun:
            return "Sunday"
        case .Mon:
            return "Monday"
        case .Tue:
            return "Tuesday"
        case .Wed:
            return "Wednesday"
        case .Thu:
            return "Thursday"
        case .Fri:
            return "Friday"
        case .Sat:
            return "Saturday"
        }
    }
    
    public func weekIndex() -> Int {
        switch self {
        case .Sun:
            return 01
        case .Mon:
            return 02
        case .Tue:
            return 03
        case .Wed:
            return 04
        case .Thu:
            return 05
        case .Fri:
            return 06
        case .Sat:
            return 07
        }
    }
}
