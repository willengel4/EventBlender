//
//  GroupMeeting.swift
//  EventBlender
//
//  Created by Will Engel on 10/15/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class GroupMeeting
{
    var id : String
    var attendees = [GroupAttendee]()
    
    init(id : String)
    {
        self.id = id
    }
}
