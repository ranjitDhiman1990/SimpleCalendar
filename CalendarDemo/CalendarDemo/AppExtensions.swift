//
//  AppExtensions.swift
//  CalendarDemo
//
//  Created by iOS Dev on 01/11/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import Foundation

extension Date {
    func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    func getFuture6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 6, to: self)
    }
    
    // Get this month's start date
    func getThisMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    // Get this month's end date
    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        var noOfMonths = 0
        
        var startDateMonthNumber = 0
        var startDateYearNumber = 0
        
        var endDateMonthNumber = 0
        var endDateYearNumber = 0
        
        if let startDateMonthStr = date.getMonthFromDate(dateFormat: "MM"), let startDateMonth = Int(startDateMonthStr) {
            startDateMonthNumber = startDateMonth
        }
        
        if let startDateYearStr = date.getYearString(), let startDateYear = Int(startDateYearStr) {
            startDateYearNumber = startDateYear
        }
        
        if let endDateMonthStr = self.getMonthFromDate(dateFormat: "MM"), let endDateMonth = Int(endDateMonthStr) {
            endDateMonthNumber = endDateMonth
        }
        
        if let endDateYearStr = self.getYearString(), let endDateYear = Int(endDateYearStr) {
            endDateYearNumber = endDateYear
        }
        
        if (endDateYearNumber - startDateYearNumber) > 0 {
            if (endDateYearNumber - startDateYearNumber) == 1 {
                noOfMonths = noOfMonths + (12 - startDateMonthNumber) + 1
                noOfMonths = noOfMonths + endDateMonthNumber
            } else if (endDateYearNumber - startDateYearNumber) > 1 {
                noOfMonths = noOfMonths + (endDateYearNumber - startDateYearNumber - 1) * 12
                noOfMonths = noOfMonths + (12 - startDateMonthNumber) + 1
                noOfMonths = noOfMonths + endDateMonthNumber
            }
        } else {
            if (endDateMonthNumber - startDateMonthNumber) == 0 {
                noOfMonths = 1
            } else {
                noOfMonths = endDateMonthNumber - startDateMonthNumber + 1
            }
        }
        print("No of months = \(noOfMonths)")
        
        return noOfMonths
        //        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    ///  Check if a date falls in between two dates
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func getMonthDetails() -> MonthDetails {
        var monthDetails = MonthDetails.init(numberOfDates: 0, monthsStartDay: 0, monthsString: "", yearsString: "")
        
        if let monthStartDate = self.getThisMonthStart() {
            let week = monthStartDate.getWeekDay()
            monthDetails.monthsStartDay = week.weekDayIndex
        }
        
        monthDetails.numberOfDates = self.getNumberOfDatesOfMonth()
        if let monthsString = self.getMonthString() {
            monthDetails.monthsString = monthsString
        }
        
        if let yearsString = self.getYearString() {
            monthDetails.yearsString = yearsString
        }
        
        return monthDetails
    }
    
    func getWeekDay () -> (weekDayIndex: Int, weekDay: String) {
        let dateFormatter = DateFormatter()
        let localTimeZoneAbbreviation = TimeZone.current.abbreviation() ?? ""
        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        let weekDayIndex = Calendar.current.component(.weekday, from: self) - 1
        let weekDay = dateFormatter.weekdaySymbols[weekDayIndex]
        
        return (weekDayIndex, weekDay)
    }
    
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    func getNumberOfDatesOfMonth() -> Int {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        
        let dateComponents = DateComponents(year: year, month: month)
        if let currentDate = calendar.date(from: dateComponents), let range = calendar.range(of: .day, in: .month, for: currentDate) {
            let numDays = range.count
            return numDays
        }
        
        return 0
    }
    
    func getDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func getMonthFromDate(dateFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func getMonthString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    func getYearString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func isToday() -> Bool {
        if Calendar.current.isDateInToday(self) {
            return true
        }
        return false
    }
}

extension String {
    func mapMonthString() -> Int {
        switch self {
        case Month.Jan.description():
            return Month.Jan.monthIndex()
        case Month.Feb.description():
            return Month.Feb.monthIndex()
        case Month.Mar.description():
            return Month.Mar.monthIndex()
        case Month.Apr.description():
            return Month.Apr.monthIndex()
        case Month .May.description():
            return Month.May.monthIndex()
        case Month.Jun.description():
            return Month.Jun.monthIndex()
        case Month.Jul.description():
            return Month.Jul.monthIndex()
        case Month.Aug.description():
            return Month.Aug.monthIndex()
        case Month.Sep.description():
            return Month.Sep.monthIndex()
        case Month.Oct.description():
            return Month.Oct.monthIndex()
        case Month.Nov.description():
            return Month.Nov.monthIndex()
        case Month.Dec.description():
            return Month.Dec.monthIndex()
        default:
            break
        }
        return 0
    }
}
