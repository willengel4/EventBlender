//
//  MeetingAvailability.swift
//  EventBlender
//
//  Created by Will Engel on 10/3/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class MeetingAvailability
{
    var startTime : String?
    var endTime : String?
    var dateFormatter : DateFormatter?
    
    init(startTime : String, endTime : String)
    {
        self.startTime = startTime
        self.endTime = endTime
        self.dateFormatter = DateFormatter()
        self.dateFormatter!.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func getNSStartTime() -> Date
    {
        return self.dateFormatter!.date(from: startTime!)!
    }
    
    func getNSEndTime() -> Date
    {
        return self.dateFormatter!.date(from: endTime!)!
    }
}
