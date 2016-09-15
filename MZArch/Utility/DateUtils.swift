//
//  DateFormater.swift
//  MZArch
//
//  Created by Jamin on 6/11/16.
//  Copyright © 2016 mz. All rights reserved.
//

import Foundation


public class DateUtils {
    
    static var sDateFormatters: NSCache = NSCache();
    
    
    public class func dateFormatter(format: String) -> NSDateFormatter {
        var result: NSDateFormatter!;
        
        if let formatter = sDateFormatters[format] as? NSDateFormatter  {
            result = formatter;
        } else {
            result = NSDateFormatter();
            result.timeZone = NSTimeZone.localTimeZone();
            result.dateFormat = format;
            sDateFormatters[format] = result;
        }
        
        return result.copy() as! NSDateFormatter;
    }
    
    
    
    
    public class func todayBrefStr() -> String {
        let formatter = self.dateFormatter("dd/MM");
        return formatter.stringFromDate(NSDate());
    }

    
    public class func todayZeroDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateFromComponents(self.todayComponents())!;
    }
   
    
    public class func todayComponents() -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        let dateComp = calendar.components([.Year, .Month, .Day, .Weekday], fromDate: NSDate());
        return dateComp;
    }
    
    
}