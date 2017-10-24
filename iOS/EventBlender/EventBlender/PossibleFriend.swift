//
//  PossibleFriend.swift
//  EventBlender
//
//  Created by Will Engel on 9/25/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class PossibleFriend
{
    var firstName : String?
    var lastName : String?
    var username : String?
    var friendsChecked : Bool
    
    init(firstName : String, lastName : String, username : String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        friendsChecked = false
    }
}