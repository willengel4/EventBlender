//
//  UtilityToolbox.swift
//  EventBlender
//
//  Created by Will Engel on 9/25/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

/* Has a few useful methods */
class UtilityToolbox
{
    func formatStrUrl(_ str : String) -> String
    {
        var newStr = ""
        
        for c in str.characters
        {
            if c != " "
            {
                newStr.append(c)
            }
            else
            {
                newStr.append("%20")
            }
        }
        
        return newStr
    }
    
    func strNoSpaces(_ str : String) -> String
    {
        var newStr = ""
        
        for c in str.characters
        {
            if c != " "
            {
                newStr.append(c)
            }
        }
        
        return newStr
    }
}
