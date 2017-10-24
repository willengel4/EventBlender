/* A TimeRange object holds the availability status of a user over a period
 * of time (traditionally 15 minutes) */

import Foundation

class TimeRange
{
    var fromTime : String?
    var toTime : String?
    var isAvailable : Bool
    var toTimeFull : String?
    var fromTimeFull : String?
    
    init(fromTime : String, toTime : String, toTimeFull : String, fromTimeFull : String)
    {
        self.isAvailable = false
        setToTime(toTime)
        setFromTime(fromTime)
        self.fromTimeFull = fromTimeFull
        self.toTimeFull = toTimeFull
    }
    
    init(fromTime : String, toTime : String, toTimeFull : String, fromTimeFull : String, isAvailable : Bool)
    {
        self.fromTime = fromTime
        self.toTime = toTime
        self.isAvailable = isAvailable
        self.fromTimeFull = fromTimeFull
        self.toTimeFull = toTimeFull
    }
    
    func getFromTime() -> String
    {
        return fromTime!
    }
    
    func getToTime() -> String
    {
        return toTime!
    }
    
    func getIsAvailable() -> Bool
    {
        return isAvailable
    }
    
    func setFromTime(_ fromTime : String)
    {
        self.fromTime = fromTime
        
        var temp = ""
        var first = true
        for c in self.fromTime!.characters
        {
            if first && c == "0"
            {
                first = false
            }
            else if first
            {
                temp.append(c)
                first = false
            }
            else
            {
                temp.append(c)
            }
        }
        
        self.fromTime = temp
    }
    
    func setToTime(_ toTime : String)
    {
        self.toTime = toTime
        
        var temp = ""
        var first = true
        for c in self.toTime!.characters
        {
            if first && c == "0"
            {
                first = false
            }
            else if first
            {
                temp.append(c)
                first = false
            }
            else
            {
                temp.append(c)
            }
        }
        
        self.toTime = temp
    }
    
    func isHour() -> Bool
    {
        var endStr = ""
        var pastColon = false
        var countPastColon = 0
        
        for c in fromTime!.characters
        {
            if c == ":"
            {
                pastColon = true
            }
            else if pastColon && countPastColon < 2
            {
                endStr.append(c)
                countPastColon += 1
            }
        }
                
        return endStr == "00"
    }
    
    func setAvailable(_ isAvailable : Bool)
    {
        self.isAvailable = isAvailable
    }
}
