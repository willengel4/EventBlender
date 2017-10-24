//
//  GroupAttendee.swift
//  EventBlender
//
//  Created by Will Engel on 10/15/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class GroupAttendee
{
    var id : String
    var availableTimes = [TimeRange]()
    
    init(id : String)
    {
        self.id = id
    }
}
