//
//  CreateEventViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/24/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet var tableView: UITableView!
    var possibleAttendees = [PossibleAttendee]()
    
    @IBOutlet weak var meetingTitleTF: UITextField!
    @IBOutlet weak var meetingMinDateTimeTF: UITextField!
    @IBOutlet weak var meetingMaxDateTimeTF: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        meetingTitleTF.delegate = self
        meetingMinDateTimeTF.delegate = self
        meetingMaxDateTimeTF.delegate = self
        
        possibleAttendees = SystemDataHelper().loadUsersFriendsAsPossibleAttendees()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return possibleAttendees.count
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CreateEventViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CreateEventViewCell")! as! CreateEventViewCell
        
        cell.nameLabel.text = possibleAttendees[(indexPath as NSIndexPath).row].firstName! + " " + possibleAttendees[(indexPath as NSIndexPath).row].lastName!
        
        cell.isGoingBox.backgroundColor = possibleAttendees[(indexPath as NSIndexPath).row].isGoing! ? UIColor.init(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0) : UIColor.init(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        
        return cell
    }
    
    @IBAction func createEventTapped(_ sender: AnyObject)
    {
        let accessToken = SystemDataHelper().loadInText("access_token.txt")
        let meetingTitle = meetingTitleTF.text!
        let meetingMinDate = meetingMinDateTimeTF.text!
        let meetingMaxDate = meetingMaxDateTimeTF.text!
        
        var urlText = "http://192.168.0.12//EventBlender/api/create_meeting.php?access_token=\(accessToken!)&meeting_title=\(meetingTitle)&min_date=\(meetingMinDate)&max_date=\(meetingMaxDate)"
        
        var count = 0
        for pa : PossibleAttendee in possibleAttendees
        {
            if pa.isGoing!
            {
                urlText.append("&username\(count)=\(pa.username!)")
                count += 1
            }
        }
        
        print(urlText)
        
        urlText = UtilityToolbox().formatStrUrl(urlText)
        
        print(urlText)
        
        /* Create the api call */
        let url = URL(string: urlText)
        
        /* Create the request */
        let request = URLRequest(url: url!)
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error")
            }
                
            /* If there was no error */
            else
            {
                /* Get the response */
                let responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                
                print(responseString)
                
                self.performSegue(withIdentifier: "ReloadEvents", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        possibleAttendees[(indexPath as NSIndexPath).row].isGoing = !possibleAttendees[(indexPath as NSIndexPath).row].isGoing!
        
        tableView.reloadData()
    }
}
