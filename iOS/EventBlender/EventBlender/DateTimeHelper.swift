//
//  DateTimeHelper.swift
//  EventBlender
//
//  Created by Will Engel on 9/23/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class DateTimeHelper
{
    func getMonthName(_ dateStr : String) -> String
    {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[getMonthNum(dateStr) - 1]
    }

    func getYear(_ dateStr : String) -> Int
    {
        return Int(getSubString(dateStr, start: 0, end: 3))!
    }
    
    func getMonthNum(_ dateStr : String) -> Int
    {
        return Int(getSubString(dateStr, start: 5, end: 6))!
    }
    
    func getDay(_ dateStr : String) -> Int
    {
        return Int(getSubString(dateStr, start: 8, end: 9))!
    }
    
    func getHourMilitary(_ dateStr : String) -> Int
    {
        return Int(getSubString(dateStr, start: 11, end: 12))!
    }
    
    /* negative if 1 < 2, 0 if 1==2, + if 1>2 */
    func compare(_ dateStr1: String, dateStr2 : String) -> Int
    {
        let firstHour = getHourMilitary(dateStr1)
        let firstMinute = getMinute(dateStr1)
        let firstYear = getYear(dateStr1)
        let firstMonth = getMonthNum(dateStr1)
        let firstDay = getDay(dateStr1)
        
        let secondHour = getHourMilitary(dateStr2)
        let secondMinute = getMinute(dateStr2)
        let secondYear = getYear(dateStr2)
        let secondMonth = getMonthNum(dateStr2)
        let secondDay = getDay(dateStr2)
        
        if firstYear == secondYear
        {
            if firstMonth == secondMonth
            {
                if firstDay == secondDay
                {
                    if firstHour == secondHour
                    {
                        if firstMinute == secondMinute
                        {
                            return 0
                        }
                        else
                        {
                            return firstMinute - secondMinute
                        }
                    }
                    else
                    {
                        return firstHour - secondHour
                    }
                }
                else
                {
                    return firstDay - secondDay
                }
            }
            else
            {
                return firstMonth - secondMonth
            }
        }
        else
        {
            return firstYear - secondYear
        }
    }
    
    func getHourStandard(_ dateStr : String) -> Int
    {
        let milTime = getHourMilitary(dateStr)
        
        if milTime == 0
        {
            return 12
        }
        else if milTime > 12
        {
            return milTime % 12
        }
        else
        {
            return milTime
        }
    }
    
    func getMinute(_ dateStr : String) -> Int
    {
        return Int(getSubString(dateStr, start: 14, end: 15))!
    }
    
    func getAMorPM(_ dateStr : String) -> String
    {
        if(getHourMilitary(dateStr) >= 12)
        {
            return "PM"
        }
        else
        {
            return "AM"
        }
    }
    
    func getMonthAndDay(_ dateStr : String) -> String
    {
        return getMonthName(dateStr) + " " + String(getDay(dateStr))
    }
    
    func getSubString(_ str : String, start : Int, end : Int) -> String
    {
        var retStr = ""
        var countChar = 0
        
        for c in str.characters
        {
            if countChar >= start && countChar <= end
            {
                retStr.append(c)
            }
            
            countChar += 1
        }
        
        return retStr
    }
}
