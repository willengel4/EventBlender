//
//  PossibleAttendee.swift
//  EventBlender
//
//  Created by Will Engel on 9/24/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class PossibleAttendee
{
    var username : String?
    var firstName : String?
    var lastName : String?
    var isGoing : Bool?
    
    init(userName : String, firstName : String, lastName : String)
    {
        self.username = userName
        self.firstName = firstName
        self.lastName = lastName
        isGoing = false
    }
}
