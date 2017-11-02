//
//  Models.swift
//  CalendarDemo
//
//  Created by iOS Dev on 01/11/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import Foundation

public struct MonthDetails {
    public var numberOfDates: Int = 0
    public var monthsStartDay: Int = 0
    public var monthsString: String = ""
    public var yearsString: String = ""
    
    init(numberOfDates: Int, monthsStartDay: Int, monthsString: String, yearsString: String) {
        self.numberOfDates = numberOfDates
        self.monthsStartDay = monthsStartDay
        self.monthsString = monthsString
        self.yearsString = yearsString
    }
}
