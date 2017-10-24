//
//  AddFriendsTableViewCell.swift
//  EventBlender
//
//  Created by Will Engel on 9/25/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//


import UIKit

class AddFriendsTableViewCell: UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendsChecked: UIView!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
