//
//  EventPageViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/23/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class EventPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var currentEvent : EventObject?
    var eventAttendees = [EventAttendee]()
    
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var eventTitleLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /* Load in the current event 
         * from the system */
        currentEvent = SystemDataHelper().getCurrentEvent()
        
        print("Current Event: " + currentEvent!.eventID! + currentEvent!.eventTitle!)
        
        eventTitleLabel.text = currentEvent!.eventTitle!
        
        /* Set the time range title and
         * the event title */
        let dateTimeHelper = DateTimeHelper()
        if dateTimeHelper.getMonthAndDay(currentEvent!.eventMinDate!) == dateTimeHelper.getMonthAndDay(currentEvent!.eventMaxDate!)
        {
            timeRangeLabel.text = dateTimeHelper.getMonthAndDay(currentEvent!.eventMinDate!)
        }
        else
        {
            timeRangeLabel.text = dateTimeHelper.getMonthAndDay(currentEvent!.eventMinDate!) + " - " + dateTimeHelper.getMonthAndDay(currentEvent!.eventMaxDate!)
        }
        
        /* Load in the EventAttendee's into eventAttendees */
        eventAttendees = SystemDataHelper().loadAttendeesFromFile(currentEvent!.eventID!)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.eventAttendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:EventPageTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "EventPageTableViewCell")! as! EventPageTableViewCell
        
        cell.nameLabel.text = eventAttendees[(indexPath as NSIndexPath).row].firstName! + " " + eventAttendees[(indexPath as NSIndexPath).row].lastName!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
