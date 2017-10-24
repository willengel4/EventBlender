//
//  EventsMenuTableViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/22/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class EventsMenuTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    var events = [EventObject]()
    var hmenuShowing = false
    @IBOutlet weak var hmenu: UIView!
    
    /* days will be a list of days where the first date is the beginning of the
     * possible event time range and the last date is the end of the range */
    
    /* When the controller loads */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        events = SystemDataHelper().loadEventsFromFile()
        
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    /* When the controller is initialized */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    /* The number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return events.count
    }
    
    /* When a row is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /* Write the event id to a file */
        let eventObject = events[(indexPath as NSIndexPath).row]
        SystemDataHelper().setCurrentEvent(eventObject)
        
        print("Selected event: " + eventObject.eventID!)
        
        /* Segueue to the menu for that event */
        self.performSegue(withIdentifier: "ToEventPage", sender: nil)
    }
    
    /* When a row is rendered? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "EventMenuTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventMenuTableViewCell
        let eventObject = events[(indexPath as NSIndexPath).row]
        let dateTimeHelper = DateTimeHelper()
        
        cell.eventLabel.text = eventObject.eventTitle!
        
        if dateTimeHelper.getMonthAndDay(eventObject.eventMinDate!) == dateTimeHelper.getMonthAndDay(eventObject.eventMaxDate!)
        {
            cell.eventDateLabel.text = dateTimeHelper.getMonthAndDay(eventObject.eventMinDate!)
        }
        else
        {
            cell.eventDateLabel.text = dateTimeHelper.getMonthAndDay(eventObject.eventMinDate!) + " - " + dateTimeHelper.getMonthAndDay(eventObject.eventMaxDate!)
        }
        
        return cell
    }
    
    @IBAction func hbuttonTapped(_ sender: AnyObject)
    {
        hmenuShowing = !hmenuShowing
        
        hmenu.isHidden = !hmenuShowing
    }
    
    /* Not particularly important */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
}
