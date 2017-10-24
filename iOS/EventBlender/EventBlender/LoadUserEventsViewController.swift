//
//  LoadUserEventsViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/21/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class LoadUserEventsViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Load the access token from file system */
        let accessToken = loadInAccessToken()
        if accessToken != nil
        {
            loadUserEvents(accessToken!)
        }
        else
        {
            print("NIL ACCESS TOKEN")
        }
        
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadUserEvents(_ accessToken : String)
    {
        /* Create the api call */
        let url = URL(string: "http://192.168.0.12//EventBlender/api/get_user_events.php?access_token=\(accessToken)")
        
        print(url)
        
        /* Create the request */
        let request = URLRequest(url: url!)
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error getting user events")
            }
                
            /* If there was no error */
            else
            {
                /* Get the response */
                let responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                
                print(responseString)
                
                /* The response contains data that we have to partition */
                var eventsPart = ""
                var usersPart = ""
                var friendsPart = ""
                var availabilityPart = ""
                var groupAvPart = ""
                var countC = 0
                var readState = 0
                
                for c : Character in responseString.characters
                {
                    if c == "<"
                    {
                        countC += 1
                        
                        if countC == 6
                        {
                            readState += 1
                            countC = 0
                        }
                        else
                        {
                            var ignoringSymbol = true
                            
                            if !ignoringSymbol
                            {
                                if readState == 0
                                {
                                    eventsPart += String(c)
                                }
                                else if readState == 1
                                {
                                    usersPart += String(c)
                                }
                                else if readState == 2
                                {
                                    friendsPart += String(c)
                                }
                                else if readState == 3
                                {
                                    availabilityPart += String(c)
                                }
                                else
                                {
                                    groupAvPart += String(c)
                                }
                            }
                        }
                    }
                    else
                    {
                        countC = 0
                        
                        if readState == 0
                        {
                            eventsPart += String(c)
                        }
                        else if readState == 1
                        {
                            usersPart += String(c)
                        }
                        else if readState == 2
                        {
                            friendsPart += String(c)
                        }
                        else if readState == 3
                        {
                            availabilityPart += String(c)
                        }
                        else
                        {
                            groupAvPart += String(c)
                        }
                    }
                }
                
                print("Begin event data...")
                print(eventsPart)
                print("Begin attendee data...")
                print(usersPart)
                print("Begin friends data...")
                print(friendsPart)
                print("Begin av data...")
                print(availabilityPart)
                print("Begin group av data...")
                print(groupAvPart)
                
                let systemDataHelper = SystemDataHelper()
                systemDataHelper.writeTextToFile(eventsPart, fileName: "user_events.txt")
                systemDataHelper.writeTextToFile(usersPart, fileName: "event_attendees.txt")
                systemDataHelper.writeTextToFile(friendsPart, fileName: "user_friends.txt")
                systemDataHelper.writeTextToFile(availabilityPart, fileName: "user_availability.txt")
                systemDataHelper.writeTextToFile(groupAvPart, fileName: "group_availability.txt")
                
                /* Segue to load user's data screen */
                self.performSegue(withIdentifier: "ToMenu", sender: nil)
            }
        }
    }
    
    func loadInAccessToken() -> String?
    {
        /* The file to open that contains the access_token */
        let file = "access_token.txt"
        
        /* The document directory */
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
        {
            /* The full path to the file */
            let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
            
            do
            {
                /* Get the text in the file and return it */
                let text2 = try NSString(contentsOf: path, encoding: String.Encoding.utf8.rawValue) as String
                
                print("Loaded access token: " + text2)
                
                return text2
            }
            catch
            {
                /* If there was an error, the access token probably doesn't exist */
                print("Error reading access_token")
            }
        }
        
        return nil
    }
}
