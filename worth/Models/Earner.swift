//
//  Earner.swift
//  worth
//
//  Created by Matt Bridges on 3/14/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

import UIKit

let secondsPerYear: Double = 365 * 24 * 60 * 60

class Earner: NSObject {
    var annualSalary: Double
    var name: String
    
    private class func getYearStart() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = calendar.components(NSCalendarUnit.CalendarUnitYear, fromDate: NSDate())
        return calendar.dateFromComponents(components)!;
    }
    
    private class func getMonthStart() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.CalendarUnitMonth, fromDate: NSDate())
        return calendar.dateFromComponents(components)!;
    }
    
    private class func getDayStart() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.CalendarUnitMonth |
            NSCalendarUnit.CalendarUnitDay, fromDate: NSDate())
        return calendar.dateFromComponents(components)!;
    }
    
    private class func getHourStart() -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.CalendarUnitMonth |
            NSCalendarUnit.CalendarUnitDay |
            NSCalendarUnit.CalendarUnitHour, fromDate: NSDate())
        return calendar.dateFromComponents(components)!;
    }
    
    private class func getWeekStart() -> NSDate {
        let now = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let components = calendar.components(
            NSCalendarUnit.CalendarUnitYear |
            NSCalendarUnit.CalendarUnitMonth |
            NSCalendarUnit.CalendarUnitWeekday |
            NSCalendarUnit.CalendarUnitDay,
            fromDate:now)
        let dayStart = calendar.dateFromComponents(components)!
        var daysToSubtract = NSDateComponents()
        daysToSubtract.day = calendar.firstWeekday - components.weekday
        return calendar.dateByAddingComponents(daysToSubtract, toDate: dayStart, options: nil)!
    }
    
    init(annualSalary: Double, name: String) {
        self.annualSalary = annualSalary
        self.name = name
    }
    
    func dollarsPerSecond() -> Double {
        return annualSalary / secondsPerYear
    }
    
    func dollarsEarnedForTimeFrame(t: TimeFrame) -> Double {
        var start: NSDate
        
        switch t {
        case .Year:
            start = Earner.getYearStart()
        case .Month:
            start = Earner.getMonthStart()
        case .Week:
            start = Earner.getWeekStart()
        case .Day:
            start = Earner.getDayStart()
        }
        
        let elapsedTime = NSDate().timeIntervalSinceDate(start);
        return (elapsedTime / secondsPerYear) * self.annualSalary;
    }
}
