//
//  SystemDataHelper.swift
//  EventBlender
//
//  Created by Will Engel on 9/24/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import Foundation

class SystemDataHelper
{
    func loadInText(_ file : String) -> String?
    {
        /* The document directory */
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
        {
            /* The full path to the file */
            let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            do
            {
                /* Get the text in the file and return it */
                let text2 = try NSString(contentsOf: path, encoding: String.Encoding.utf8.rawValue) as String
                
                return text2
            }
            catch
            {
                /* If there was an error, the access token probably doesn't exist */
                print("Error reading from " + file)
            }
        }
        
        return nil
    }
    
    /* This function will write the specified text to the specified file */
    func writeTextToFile(_ text : String, fileName : String)
    {
        /* Get the path to the documents directory */
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
        {
            /* The full path */
            let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName)
            
            do
            {
                /* Do the writing */
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch
            {
                print("error writing to " + fileName)
            }
        }
    }
    
    /* This will set the currently selected event by placing the
     * event's id in the current_event.txt file */
    func setCurrentEvent(_ currentEvent : EventObject)
    {
        print("Wrote out: " + currentEvent.eventID!)
        
        writeTextToFile(currentEvent.eventID!, fileName: "current_event.txt")
    }
    
    /* Loads in the current event id from a file as well as all of the user's events
     * then, searches through the events for a match, returns the matchinig object */
    func getCurrentEvent() -> EventObject?
    {
        /* Loads in the event id */
        let eventID = loadInText("current_event.txt")
        
        print("read in: " + eventID!)
        
        /* Loads all the events */
        let events = loadEventsFromFile()
        
        /* Searches for the match */
        for eo : EventObject in events
        {
            if eo.eventID == eventID
            {
                print("Found match: " + eo.eventID!)
                return eo
            }
        }
        
        /* Returns nil if not found */
        return nil
    }
    
    func loadAttendeesFromFile(_ currentEventID : String) -> [EventAttendee]
    {
        print("beginning attendee loading")
        
        /* Get the attendee data from the file system */
        let data = loadInText("event_attendees.txt")!
        
        var attendees = [EventAttendee]() //the returning list
        
        /* firstName, lastName, and meetingID. Each line returned from the
         * server will contain a field for each variable */
        var firstName = ""
        var lastName = ""
        var meetingID = ""
        
        /* currentToken will hold a block of text that comes in between the '^^^'
         * dCount is used to keep track of '^', sometimes '^' will be part of the
         * actual input string */
        var currentToken = ""
        var dCount = 0
        
        /* Go through the entire response character by character */
        for c in data.characters
        {
            /* If the current character is the '^' seperator character */
            if c == "^"
            {
                /* Increment the delimiter count */
                dCount += 1
                
                /* Three delims in a row means new token, store the current token */
                if dCount == 3
                {
                    if firstName == ""
                    {
                        firstName = currentToken
                        print("First Name: " + firstName)
                    }
                    else if lastName == ""
                    {
                        lastName = currentToken
                        print("Last Name: " + lastName)
                    }
                    
                    /* Once the currentToken has been stored, clear it out and reset the dCount */
                    currentToken = ""
                    dCount = 0
                }
            }
                
            /* If the current character is the newLine character, this
             * is the end of that object's parsing period. The maxDate should be set to
             * the current token, the EventObject will be created and added to the list */
            else if c == "\n"
            {
                /* Store currentToken in maxDate */
                meetingID = currentToken
                print("Meeting ID: " + meetingID)
                
                /* Now that we have all fields required to make an EventObject,
                 * make it and add it to the list */
                let attendee = EventAttendee(firstName: firstName, lastName: lastName, meetingID: meetingID)
                
                if meetingID == currentEventID
                {
                    attendees.append(attendee)
                }
                
                /* Clear everything so that the next object can be parsed */
                currentToken = ""
                dCount = 0
                firstName = ""
                lastName = ""
                meetingID = ""
            }
                
            /* If the current character is just an ordinary character,
             * add the current character to the currentToken, and ensure
             * that the dCount is 0 */
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        print("finished attendee loading")
        
        /* attendees should now be filled with EventAttendee's, return it */
        return attendees
    }
    
    func loadUsersFriends() -> [FriendObject]
    {
        print("beginning users friend loading")
        
        /* Get the event data from the file system */
        let data = loadInText("user_friends.txt")!
        
        var friends = [FriendObject]() //the returning list
        
        /* Event title, minDate and maxDate. Each line returned from the
         * server will contain a field for each variable */
        var firstName = ""
        var lastName = ""
        var username = ""
        
        /* currentToken will hold a block of text that comes in between the '^^^'
         * dCount is used to keep track of '^', sometimes '^' will be part of the
         * actual input string */
        var currentToken = ""
        var dCount = 0
        
        /* Go through the entire response character by character */
        for c in data.characters
        {
            /* If the current character is the '^' seperator character */
            if c == "^"
            {
                /* Increment the delimiter count */
                dCount += 1
                
                /* Three delims in a row means new token, store the current token */
                if dCount == 3
                {
                    /* The token will be stored in id if the id is blank,
                     * title if and title is currently blank,
                     * and minDate if title has text and minDate is blank */
                    if firstName == ""
                    {
                        firstName = currentToken
                        print("firstName: " + firstName)
                    }
                    else if lastName == ""
                    {
                        lastName = currentToken
                        print("lastName: " + lastName)
                    }
                    
                    /* Once the currentToken has been stored, clear it out and reset the dCount */
                    currentToken = ""
                    dCount = 0
                }
            }
                
                /* If the current character is the newLine character, this
                 * is the end of that object's parsing period. The maxDate should be set to
                 * the current token, the EventObject will be created and added to the list */
            else if c == "\n"
            {
                /* Store currentToken in maxDate */
                username = currentToken
                print("username: " + username)
                
                /* Now that we have all fields required to make an EventObject,
                 * make it and add it to the list */
                let friendObject = FriendObject(username: username, firstName: firstName, lastName: lastName)
                friends.append(friendObject)
                
                /* Clear everything so that the next object can be parsed */
                currentToken = ""
                dCount = 0
                firstName = ""
                lastName = ""
                username = ""
            }
                
                /* If the current character is just an ordinary character,
                 * add the current character to the currentToken, and ensure
                 * that the dCount is 0 */
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        print("finished event loading")
        
        /* eventObjects should now be filled with EventObject's, return it */
        return friends
    }
    
    func searchMeetings(_ meetings : [Meeting], meetingID : String) -> Meeting?
    {
        for m in meetings
        {
            if m.meetingID! == meetingID
            {
                return m
            }
        }
        
        return nil
    }
    
    func searchAttendees(userID : String, meeting : GroupMeeting) -> GroupAttendee
    {
        for attendee in meeting.attendees
        {
            if attendee.id == userID
            {
                return attendee
            }
        }
        
        let newAttendee = GroupAttendee(id: userID)
        meeting.attendees.append(newAttendee)
        return newAttendee
    }
    
    func loadGroupAvailability(meetingID : String) -> GroupMeeting
    {
        let data = loadInText("group_availability.txt")
        
        var meeting = GroupMeeting(id: meetingID)
        
        var meeting_id = ""
        var user_id = ""
        var start_date_time = ""
        var end_date_time = ""
        var start_standard = ""
        var end_standard = ""
        
        var currentToken = ""
        var dCount = 0
        
        for c in data!.characters
        {
            if c == "^"
            {
                dCount += 1
                
                if dCount == 3
                {
                    if meeting_id == ""
                    {
                        meeting_id = currentToken
                    }
                    else if user_id == ""
                    {
                        user_id = currentToken
                    }
                    else if start_date_time == ""
                    {
                        start_date_time = currentToken
                    }
                    else if end_date_time == ""
                    {
                        end_date_time = currentToken
                    }
                    else
                    {
                        start_standard = currentToken
                    }
                    
                    dCount = 0
                    currentToken = ""
                }
            }
            else if c == "\n"
            {
                end_standard = currentToken
                
                /* If it is the right meeting */
                if(meeting_id == meetingID)
                {
                    /* Find the correct attendee to add the time range too */
                    let attendee = searchAttendees(userID: user_id, meeting: meeting)
                    
                    /* Create and add the range */
                    let range = TimeRange(fromTime: start_standard, toTime: end_standard, toTimeFull: end_date_time, fromTimeFull: start_date_time)
                    attendee.availableTimes.append(range)
                }
                
                currentToken = ""
                dCount = 0
                meeting_id = ""
                user_id = ""
                start_date_time = ""
                end_date_time = ""
                start_standard = ""
                end_standard = ""
            }
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        print("Displaying av data for meeting: " + meeting.id)
        
        for attendee in meeting.attendees
        {
            print("Attendee: " + attendee.id)
            for time_range in attendee.availableTimes
            {
                print("\(time_range.fromTime!) - \(time_range.toTime!)")
            }
            print("")
        }
        
        return meeting
    }
    
    func loadAvailabilityForMeeting(_ m_id : String, fileName : String) -> [Meeting]
    {
        let data = loadInText(fileName)!
        
        var meetings = [Meeting]()
        
        /* Event title, minDate and maxDate. Each line returned from the
         * server will contain a field for each variable */
        var meeting_id = ""
        var start_date_time = ""
        var end_date_time = ""
        
        /* currentToken will hold a block of text that comes in between the '^^^'
         * dCount is used to keep track of '^', sometimes '^' will be part of the
         * actual input string */
        var currentToken = ""
        var dCount = 0
        
        /* Go through the entire response character by character */
        for c in data.characters
        {
            /* If the current character is the '^' seperator character */
            if c == "^"
            {
                /* Increment the delimiter count */
                dCount += 1
                
                /* Three delims in a row means new token, store the current token */
                if dCount == 3
                {
                    /* The token will be stored in id if the id is blank,
                     * title if and title is currently blank,
                     * and minDate if title has text and minDate is blank */
                    if meeting_id == ""
                    {
                        meeting_id = currentToken
                        print("meeting_id: " + meeting_id)
                    }
                    else if start_date_time == ""
                    {
                        start_date_time = currentToken
                        print("start_date_time: " + start_date_time)
                    }
                    
                    /* Once the currentToken has been stored, clear it out and reset the dCount */
                    currentToken = ""
                    dCount = 0
                }
            }
                
                /* If the current character is the newLine character, this
                 * is the end of that object's parsing period. The maxDate should be set to
                 * the current token, the EventObject will be created and added to the list */
            else if c == "\n"
            {
                /* Store currentToken in maxDate */
                end_date_time = currentToken
                print("end_date_time: " + end_date_time)
                
                var m = self.searchMeetings(meetings, meetingID: meeting_id)
                
                if m == nil
                {
                    m = Meeting(meetingID: meeting_id)
                    meetings.append(m!)
                }
                
                if m_id == meeting_id
                {
                    let a = MeetingAvailability(startTime: start_date_time, endTime: end_date_time)
                    m!.availlable.append(a)
                }
                
                /* Clear everything so that the next object can be parsed */
                currentToken = ""
                dCount = 0
                meeting_id = ""
                start_date_time = ""
                end_date_time = ""
            }
                
            /* If the current character is just an ordinary character,
             * add the current character to the currentToken, and ensure
             * that the dCount is 0 */
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        return meetings
    }
    
    func loadUserAvailability() -> [Meeting]
    {
        let data = loadInText("user_availability.txt")!
        
        var meetings = [Meeting]()

        /* Event title, minDate and maxDate. Each line returned from the
         * server will contain a field for each variable */
        var meeting_id = ""
        var start_date_time = ""
        var end_date_time = ""
        
        /* currentToken will hold a block of text that comes in between the '^^^'
         * dCount is used to keep track of '^', sometimes '^' will be part of the
         * actual input string */
        var currentToken = ""
        var dCount = 0
        
        /* Go through the entire response character by character */
        for c in data.characters
        {
            /* If the current character is the '^' seperator character */
            if c == "^"
            {
                /* Increment the delimiter count */
                dCount += 1
                
                /* Three delims in a row means new token, store the current token */
                if dCount == 3
                {
                    /* The token will be stored in id if the id is blank,
                     * title if and title is currently blank,
                     * and minDate if title has text and minDate is blank */
                    if meeting_id == ""
                    {
                        meeting_id = currentToken
                        print("meeting_id: " + meeting_id)
                    }
                    else if start_date_time == ""
                    {
                        start_date_time = currentToken
                        print("start_date_time: " + start_date_time)
                    }
                    
                    /* Once the currentToken has been stored, clear it out and reset the dCount */
                    currentToken = ""
                    dCount = 0
                }
            }
                
            /* If the current character is the newLine character, this
             * is the end of that object's parsing period. The maxDate should be set to
             * the current token, the EventObject will be created and added to the list */
            else if c == "\n"
            {
                /* Store currentToken in maxDate */
                end_date_time = currentToken
                print("end_date_time: " + end_date_time)
                
                var m = self.searchMeetings(meetings, meetingID: meeting_id)
                
                if m == nil
                {
                    m = Meeting(meetingID: meeting_id)
                    meetings.append(m!)
                }
                
                let a = MeetingAvailability(startTime: start_date_time, endTime: end_date_time)
                m!.availlable.append(a)
                
                /* Clear everything so that the next object can be parsed */
                currentToken = ""
                dCount = 0
                meeting_id = ""
                start_date_time = ""
                end_date_time = ""
            }
                
            /* If the current character is just an ordinary character,
             * add the current character to the currentToken, and ensure
             * that the dCount is 0 */
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        return meetings
    }
    
    func loadUsersFriendsAsPossibleAttendees() -> [PossibleAttendee]
    {
        print("beginning users friend loading")
        
        /* Get the event data from the file system */
        let data = loadInText("user_friends.txt")!
        
        var friends = [PossibleAttendee]() //the returning list
        
        /* Event title, minDate and maxDate. Each line returned from the
         * server will contain a field for each variable */
        var firstName = ""
        var lastName = ""
        var username = ""
        
        /* currentToken will hold a block of text that comes in between the '^^^'
         * dCount is used to keep track of '^', sometimes '^' will be part of the
         * actual input string */
        var currentToken = ""
        var dCount = 0
        
        /* Go through the entire response character by character */
        for c in data.characters
        {
            /* If the current character is the '^' seperator character */
            if c == "^"
            {
                /* Increment the delimiter count */
                dCount += 1
                
                /* Three delims in a row means new token, store the current token */
                if dCount == 3
                {
                    /* The token will be stored in id if the id is blank,
                     * title if and title is currently blank,
                     * and minDate if title has text and minDate is blank */
                    if firstName == ""
                    {
                        firstName = currentToken
                        print("firstName: " + firstName)
                    }
                    else if lastName == ""
                    {
                        lastName = currentToken
                        print("lastName: " + lastName)
                    }
                    
                    /* Once the currentToken has been stored, clear it out and reset the dCount */
                    currentToken = ""
                    dCount = 0
                }
            }
                
                /* If the current character is the newLine character, this
                 * is the end of that object's parsing period. The maxDate should be set to
                 * the current token, the EventObject will be created and added to the list */
            else if c == "\n"
            {
                /* Store currentToken in maxDate */
                username = currentToken
                print("username: " + username)
                
                /* Now that we have all fields required to make an EventObject,
                 * make it and add it to the list */
                let possibleAttendee = PossibleAttendee(userName: username, firstName: firstName, lastName: lastName)
                friends.append(possibleAttendee)
                
                /* Clear everything so that the next object can be parsed */
                currentToken = ""
                dCount = 0
                firstName = ""
                lastName = ""
                username = ""
            }
                
                /* If the current character is just an ordinary character,
                 * add the current character to the currentToken, and ensure
                 * that the dCount is 0 */
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        print("finished event loading")
        
        /* eventObjects should now be filled with EventObject's, return it */
        return friends
    }
    
    func writeUsersFriends(_ userFriends : [FriendObject])
    {
        var fileContents = ""
        
        for friend in userFriends
        {
            fileContents += friend.firstName! + "^^^" + friend.lastName! + "^^^" + friend.username! + "\n"
        }
        
        print("User's current friends...")
        print(fileContents)
        
        writeTextToFile(fileContents, fileName: "user_friends.txt")
    }
    
    /* This function will parse a string that resembles the following format:
     * ID^^^TITLE^^^MIN_DATE^^^MAX_DATE
     * ...
     * ...
     * It will return a list of EventObject's of the parsed dataa */
    func loadEventsFromFile() -> [EventObject]
    {
        print("beginning event loading")
        
        /* Get the event data from the file system */
        let data = loadInText("user_events.txt")!
        
        var eventObjects = [EventObject]() //the returning list
        
        /* Event title, minDate and maxDate. Each line returned from the
         * server will contain a field for each variable */
        var id = ""
        var title = ""
        var minDate = ""
        var maxDate = ""
        
        /* currentToken will hold a block of text that comes in between the '^^^'
         * dCount is used to keep track of '^', sometimes '^' will be part of the
         * actual input string */
        var currentToken = ""
        var dCount = 0
        
        /* Go through the entire response character by character */
        for c in data.characters
        {
            /* If the current character is the '^' seperator character */
            if c == "^"
            {
                /* Increment the delimiter count */
                dCount += 1
                
                /* Three delims in a row means new token, store the current token */
                if dCount == 3
                {
                    /* The token will be stored in id if the id is blank,
                     * title if and title is currently blank,
                     * and minDate if title has text and minDate is blank */
                    if id == ""
                    {
                        id = currentToken
                        print("ID: " + id)
                    }
                    else if title == ""
                    {
                        title = currentToken
                        print("Title: " + title)
                    }
                    else if minDate == ""
                    {
                        minDate = currentToken
                        print("mindate: " + minDate)
                    }
                    
                    /* Once the currentToken has been stored, clear it out and reset the dCount */
                    currentToken = ""
                    dCount = 0
                }
            }
                
                /* If the current character is the newLine character, this
                 * is the end of that object's parsing period. The maxDate should be set to
                 * the current token, the EventObject will be created and added to the list */
            else if c == "\n"
            {
                /* Store currentToken in maxDate */
                maxDate = currentToken
                print("maxdate: " + maxDate)
                
                /* Now that we have all fields required to make an EventObject,
                 * make it and add it to the list */
                let eventObject = EventObject(eventID: id, eventTitle: title, eventMinDate: minDate, eventMaxDate: maxDate)
                eventObjects.append(eventObject)
                
                /* Clear everything so that the next object can be parsed */
                currentToken = ""
                dCount = 0
                title = ""
                minDate = ""
                maxDate = ""
                id = ""
            }
                
                /* If the current character is just an ordinary character,
                 * add the current character to the currentToken, and ensure
                 * that the dCount is 0 */
            else
            {
                currentToken.append(c)
                dCount = 0
            }
        }
        
        print("finished event loading")
        
        /* eventObjects should now be filled with EventObject's, return it */
        return eventObjects
    }
}
