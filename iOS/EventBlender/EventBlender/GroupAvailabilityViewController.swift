//
//  GroupAvailabilityViewController.swift
//  EventBlender
//
//  Created by Will Engel on 10/1/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class GroupAvailabilityViewController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    var days = [DayObject]()
    var currentDate : DayObject?
    var currentIndex : Int?
    var currentEvent : EventObject?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    /* When the controller loads */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        prevButton.setTitle("", for: UIControlState())
        
        if days.count > 1
        {
            nextButton.setTitle(days[1].getShortDate(), for: UIControlState())
        }
        else
        {
            nextButton.setTitle("", for: UIControlState())
        }
        
        dateLabel.text = currentDate!.getShortDate()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    /* When the controller is initialized */
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        currentEvent = SystemDataHelper().getCurrentEvent()
        
        var meetingObject = SystemDataHelper().loadGroupAvailability(meetingID: currentEvent!.eventID!)
        
        loadDays(currentEvent!.eventMinDate!, maxDateStr: currentEvent!.eventMaxDate!, meetingObject: meetingObject)
        currentIndex = 0
        currentDate = days[currentIndex!]
    }
    
    func loadDays(_ minDateStr : String, maxDateStr : String, meetingObject : GroupMeeting)
    {
        /* Store the current date and max date in nsdate objects */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var currentDate = dateFormatter.date(from: minDateStr)
        var maxDate = dateFormatter.date(from: maxDateStr)
        
        /* The current date will be incrementing by 1, go until it is > maxDate */
        while currentDate!.compare(maxDate!) == ComparisonResult.orderedAscending || currentDate!.compare(maxDate!) == ComparisonResult.orderedSame
        {
            /* Create a new DayObject with the current date, and add that DayObject to days */
            days += [DayObject(date: (currentDate! as NSDate).copy() as! Date, groupAvailability: meetingObject)]
            
            /* Add 1 day to currentDate */
            currentDate = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: currentDate!, options: NSCalendar.Options.init(rawValue: 0))
            
            print(dateFormatter.string(from: currentDate!) + "  ---  " + dateFormatter.string(from: maxDate!))
        }
    }
    
    /* The number of rows */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentDate!.timeRanges.count
    }
    
    /* When a row is selected */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    /* When a row is rendered? */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "GroupAvailabilityViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GroupAvailabilityViewCell
        
        let timeRange = currentDate!.timeRanges[(indexPath as NSIndexPath).row]
        
        cell.setTimeFrame(timeRange.getFromTime(), toTime: timeRange.getToTime())
        
        /* Fill the lower background */
        if(timeRange.getIsAvailable())
        {
            cell.lowerBG.backgroundColor = UIColor.init(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
        }
        else
        {
            cell.lowerBG.backgroundColor = UIColor.init(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        }
        
        /* Fill the upper background */
        
        /* If first cell or last cell */
        if (indexPath as NSIndexPath).row == 0
        {
            cell.upperBG.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.27, alpha: 1.0)
        }
        else if (indexPath as NSIndexPath).row == currentDate!.timeRanges.count - 1
        {
            if currentDate!.timeRanges[(indexPath as NSIndexPath).row - 1].getIsAvailable()
            {
                cell.upperBG.backgroundColor = UIColor.init(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
            }
            else
            {
                cell.upperBG.backgroundColor = UIColor.init(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
            }
            
            cell.lowerBG.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.27, alpha: 1.0)
        }
            
        /* Middle cells */
        else
        {
            let prevTimeRange = currentDate!.timeRanges[(indexPath as NSIndexPath).row - 1]
            
            if(prevTimeRange.getIsAvailable())
            {
                cell.upperBG.backgroundColor = UIColor.init(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
            }
            else
            {
                cell.upperBG.backgroundColor = UIColor.init(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
            }
        }
        
        /* We are trying to get the time box to only display on the hour
         * Excludes otherwise */
        if !timeRange.isHour()
        {
            cell.fromTime.isHidden = true
        }
        else
        {
            cell.fromTime.isHidden = false
        }
        
        return cell
    }
    
    @IBAction func prevButtonTapped(_ sender: AnyObject)
    {
        /* Check if it is valid to go to the previous day */
        if currentIndex <= 0
        {
            return
        }
        
        /* Go to the previous day */
        currentIndex = currentIndex! - 1
        
        /* Update the current date */
        currentDate = days[currentIndex!]
        
        /* Update the next and previous day buttons */
        nextButton.setTitle(days[currentIndex! + 1].getShortDate(), for: UIControlState())
        if currentIndex > 0
        {
            prevButton.setTitle(days[currentIndex! - 1].getShortDate(), for: UIControlState())
        }
        else
        {
            prevButton.setTitle("", for: UIControlState())
        }
        
        /* update the title of the page */
        self.dateLabel.text = currentDate?.getShortDate()
        
        /* Reload the table view */
        self.tableView.reloadData()
    }
    
    @IBAction func nextButtonTapped(_ sender: AnyObject)
    {
        /* Check if it is valid to go to the previous day */
        if currentIndex >= days.count - 1
        {
            return
        }
        
        /* Go to the previous day */
        currentIndex = currentIndex! + 1
        
        /* Update the current date */
        currentDate = days[currentIndex!]
        
        /* Update the next and previous day buttons */
        prevButton.setTitle(days[currentIndex! - 1].getShortDate(), for: UIControlState())
        if currentIndex < days.count - 1
        {
            nextButton.setTitle(days[currentIndex! + 1].getShortDate(), for: UIControlState())
        }
        else
        {
            nextButton.setTitle("", for: UIControlState())
        }
        
        /* update the title of the page */
        self.dateLabel.text = currentDate?.getShortDate()
        
        /* Reload the table view */
        self.tableView.reloadData()
    }
    
    /* Not particularly important */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
}
