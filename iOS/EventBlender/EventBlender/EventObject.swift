//
//  EventObject.swift
//  EventBlender
//
//  Created by Will Engel on 9/21/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class  EventObject
{
    var eventTitle : String?
    var eventMinDate : String?
    var eventMaxDate : String?
    var eventID : String?
    var attendees = [EventAttendee]()
    
    init(eventID: String, eventTitle: String, eventMinDate: String, eventMaxDate: String)
    {
        self.eventTitle = eventTitle
        self.eventMinDate = eventMinDate
        self.eventMaxDate = eventMaxDate
        self.eventID = eventID
    }
}