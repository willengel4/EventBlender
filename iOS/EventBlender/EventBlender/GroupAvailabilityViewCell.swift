//
//  GroupAvailabilityViewCell.swift
//  EventBlender
//
//  Created by Will Engel on 10/2/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class GroupAvailabilityViewCell: UITableViewCell
{
    @IBOutlet weak var lowerBG: UIView!
    @IBOutlet weak var upperBG: UIView!
    @IBOutlet weak var fromTime: UILabel!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func setTimeFrame(_ fromTime : String, toTime : String)
    {
        self.fromTime.text = fromTime
    }
}
