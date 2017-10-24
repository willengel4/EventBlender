//
//  EventAttendee.swift
//  EventBlender
//
//  Created by Will Engel on 9/24/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class  EventAttendee
{
    var firstName : String?
    var lastName : String?
    var meetingID : String?
    var eventObject : EventObject?
    
    init(firstName : String, lastName : String, meetingID : String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.meetingID = meetingID
    }
}