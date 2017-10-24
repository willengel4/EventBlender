//
//  SignUpViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/18/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController
{
    
    @IBOutlet weak var userNameOutlet: UITextField!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func SignUpTap(_ sender: AnyObject)
    {
        /* Retrieving user input from text boxes */
        let firstNameText = firstNameOutlet.text!
        let lastNameText = lastNameOutlet.text!
        let userName = userNameOutlet.text!
        let passwordText = passwordOutlet.text!
        
        /* Create the api call */
        let url = NSURL(string: "http://192.168.0.12//EventBlender/api/sign_up_user.php?userName=\(userName)&password=\(passwordText)&firstName=\(firstNameText)&lastName=\(lastNameText)")
        
        /* Create the request */
        let request = NSURLRequest(url: url! as URL)
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error signing up user")
            }
                
                /* If there was no error */
            else
            {
                /* Get the response */
                var responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                
                responseString = UtilityToolbox().strNoSpaces(responseString)
                
                print(responseString)
                
                /* The file name */
                let file = "access_token.txt"
                
                /* Get the path to the documents directory */
                if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
                {
                    /* The full path */
                    let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file)
                    
                    do
                    {
                        /* Do the writing */
                        try responseString.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
                        
                        /* Segue to load user's data screen */
                        self.performSegue(withIdentifier: "SignUpSegway", sender: nil)
                    }
                    catch
                    {
                        print("error writing to access_token")
                    }
                }
            }
        }
    }
}
