//
//  EventMenuTableViewCell.swift
//  EventBlender
//
//  Created by Will Engel on 9/22/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//


import UIKit

class EventMenuTableViewCell: UITableViewCell
{
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var eventDateLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
