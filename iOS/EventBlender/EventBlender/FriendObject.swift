//
//  FriendObject.swift
//  EventBlender
//
//  Created by Will Engel on 9/24/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

/* In the friends list */
class FriendObject
{
    var username : String?
    var firstName : String?
    var lastName : String?
    
    init(username : String, firstName : String, lastName : String)
    {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
    }
}
