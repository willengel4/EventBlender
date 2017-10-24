//
//  AddFriendsViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/25/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//


import UIKit

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet var tableView: UITableView!
    var possibleFriends = [PossibleFriend]()
    @IBOutlet weak var searchBar: UITextField!
    var userFriends = [FriendObject]()
    
    @IBOutlet weak var alertMenu: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        userFriends = SystemDataHelper().loadUsersFriends()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return possibleFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:AddFriendsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "AddFriendsTableViewCell")! as! AddFriendsTableViewCell
        
        cell.nameLabel.text = possibleFriends[(indexPath as NSIndexPath).row].firstName! + " " + possibleFriends[(indexPath as NSIndexPath).row].lastName! + " (" + possibleFriends[(indexPath as NSIndexPath).row].username! + ")"
        
        cell.friendsChecked.backgroundColor = possibleFriends[(indexPath as NSIndexPath).row].friendsChecked ? UIColor.init(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0) : UIColor.init(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        possibleFriends[(indexPath as NSIndexPath).row].friendsChecked = !possibleFriends[(indexPath as NSIndexPath).row].friendsChecked
        
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addFriendTapped(_ sender: AnyObject)
    {
        var urlText = "http://192.168.0.12//EventBlender/api/add_friends.php?access_token=\(SystemDataHelper().loadInText("access_token.txt")!)"
        var appendedUrlText = ""
        
        var count = 0
        for pf in possibleFriends
        {
            if pf.friendsChecked
            {
                userFriends.append(FriendObject(username: pf.username!, firstName: pf.firstName!, lastName: pf.lastName!))
                appendedUrlText.append("&friend_username" + String(count) + "=" + pf.username!)
                count += 1
            }
        }

        SystemDataHelper().writeUsersFriends(userFriends)
        
        /* Hit api as well */
        if appendedUrlText != ""
        {
            urlText.append(appendedUrlText)
            
            print("Hitting: " + urlText)
            
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
                    
                    self.alertMenu.isHidden = false
                }
            }
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: AnyObject)
    {
        alertMenu.isHidden = true
    }
    
    @IBAction func searchTapped(_ sender: AnyObject)
    {
        possibleFriends.removeAll()
        
        var urlText = "http://192.168.0.12//EventBlender/api/search_users.php?search_str=\(searchBar.text!)"
        urlText = UtilityToolbox().formatStrUrl(urlText)
        
        print(urlText)
        
        /* Create the api call */
        let url = URL(string: urlText)
        
        /* Create the request */
        let request = URLRequest(url: url!)
        
        /* Clear out the current contents */
        self.possibleFriends.removeAll()
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error searching for users")
            }
                
                /* If there was no error */
            else
            {
                /* Get the response */
                let responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                
                print(responseString)
                
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
                for c in responseString.characters
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
                                print("Frist Name: " + firstName)
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
                        username = currentToken
                        print("username: " + username)
                        
                        /* Now that we have all fields required to make an EventObject,
                         * make it and add it to the list */
                        let possibleFriend = PossibleFriend(firstName: firstName, lastName: lastName, username: username)
                        self.possibleFriends.append(possibleFriend)
                        
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
                
                self.tableView.reloadData()
            }
        }
    }
}

