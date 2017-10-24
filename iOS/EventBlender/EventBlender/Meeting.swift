//
//  Meeting.swift
//  EventBlender
//
//  Created by Will Engel on 10/3/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class Meeting
{
    var meetingID : String?
    var availlable = [MeetingAvailability]()
    
    init(meetingID : String)
    {
        self.meetingID = meetingID
    }
}