/* A DayObject is responsible for storing a whole day's worth of TimeRange objects */

import Foundation

class DayObject
{
    var date : Date
    var timeRanges = [TimeRange]()
    
    init(date : Date, userAvailability : [Meeting])
    {
        self.date = date
        
        loadTimeRanges(userAvailability)
    }
    
    init(date: Date, groupAvailability : GroupMeeting)
    {
        self.date = date
        
        loadTimeRanges(groupAvailability: groupAvailability)
    }
    
    func loadTimeRanges(groupAvailability : GroupMeeting)
    {
        /* 12:00 AM */
        var timeObject = (date as NSDate).copy() as! Date
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd%20HH:mm:ss"
        
        for i in 0...96
        {
            let currentTime = timeFormatter.string(from: timeObject)
            let currentTimeFull = fullDateFormatter.string(from: timeObject)
            
            let isAvailable = searchAttendeesAvailability(timeObject: timeObject, avData: groupAvailability)
            
            timeObject = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 15, to: timeObject, options: NSCalendar.Options.init(rawValue: 0))!
            
            let nextTime = timeFormatter.string(from: timeObject)
            let nextTimeFull = fullDateFormatter.string(from: timeObject)
            
            let timeRangeObj = TimeRange(fromTime: currentTime, toTime: nextTime, toTimeFull: nextTimeFull, fromTimeFull: currentTimeFull)
            
            timeRangeObj.setAvailable(isAvailable)
            
            timeRanges += [timeRangeObj]
        }
    }
    
    func loadTimeRanges(_ userAvailability : [Meeting])
    {
        /* 12:00 AM */
        var timeObject = (date as NSDate).copy() as! Date
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd%20HH:mm:ss"
        
        for i in 0...96
        {
            let currentTime = timeFormatter.string(from: timeObject)
            let currentTimeFull = fullDateFormatter.string(from: timeObject)
            
            let isAvailable = searchForAvailability(timeObject, avData: userAvailability)
            
            timeObject = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 15, to: timeObject, options: NSCalendar.Options.init(rawValue: 0))!
            
            let nextTime = timeFormatter.string(from: timeObject)
            let nextTimeFull = fullDateFormatter.string(from: timeObject)
            
            let timeRangeObj = TimeRange(fromTime: currentTime, toTime: nextTime, toTimeFull: nextTimeFull, fromTimeFull: currentTimeFull)
            
            timeRangeObj.setAvailable(isAvailable)
            
            timeRanges += [timeRangeObj]
        }
    }
    
    func searchAttendeesAvailability(timeObject : Date, avData : GroupMeeting) -> Bool
    {
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for attendee in avData.attendees
        {
            var attendeeAvailable = false
            
            for timeRange in attendee.availableTimes
            {
                /* If the attendee is available during the time */
                if (fullDateFormatter.date(from: timeRange.fromTimeFull!)?.compare(timeObject) == ComparisonResult.orderedAscending || fullDateFormatter.date(from: timeRange.fromTimeFull!)?.compare(timeObject) == ComparisonResult.orderedSame) && fullDateFormatter.date(from: timeRange.toTimeFull!)?.compare(timeObject) == ComparisonResult.orderedDescending
                {
                    attendeeAvailable = true
                }
            }
            
            if !attendeeAvailable
            {
                return false
            }
        }
        
        return true
    }
    
    /* Will search for a MeetingAvailability object that surrounds timeObject */
    func searchForAvailability(_ timeObject : Date, avData : [Meeting]) -> Bool
    {
        for meeting in avData
        {
            for av in meeting.availlable
            {
                let avStart = av.getNSStartTime()
                let avEnd = av.getNSEndTime()
                
                if (timeObject.compare(avStart as Date) == ComparisonResult.orderedDescending || timeObject.compare(avStart as Date) == ComparisonResult.orderedSame) && timeObject.compare(avEnd as Date) == ComparisonResult.orderedAscending
                {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getShortDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        return formatter.string(from: date)
        
    }
}
