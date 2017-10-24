//
//  SignInViewController.swift
//  EventBlender
//
//  Created by Will Engel on 9/18/16.
//  Copyright © 2016 SnappyApps. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userNameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    var currentTBYVal = CGFloat(0.0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        print("helloooo")
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SignInTapped(_ sender: AnyObject)
    {
        /* Retrieving user input from text boxes */
        let userName = userNameOutlet.text!
        let passwordText = passwordOutlet.text!
        
        /* Create the api call */
        let url = URL(string: "http://192.168.0.12//EventBlender/api/sign_in_user.php?userName=\(userName)&password=\(passwordText)")
        
        /* Create the request */
        let request = URLRequest(url: url!)
        
        /* Make the request, get the response */
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main)
        {(response, data, error) in
            
            /* If there was an error */
            if(error != nil)
            {
                print("Error signing in user")
            }
                
            /* If there was no error */
            else
            {
                /* Get the response */
                let responseString = NSMutableString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                
                print(responseString)
                
                /* The file name */
                let file = "access_token.txt"
                
                /* Get the path to the documents directory */
                if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
                {
                    /* The full path */
                    let path = URL(fileURLWithPath: dir).appendingPathComponent(file)
                    
                    do
                    {
                        /* Do the writing */
                        try responseString.write(to: path, atomically: false, encoding: String.Encoding.utf8.rawValue)
                        
                        /* Segue to load user's data screen */
                        self.performSegue(withIdentifier: "SignInSeque", sender: nil)
                    }
                    catch
                    {
                        print("error writing to access_token")
                    }
                }
            }
        }
    }
    
    @IBAction func passwordEditBegin(_ sender: AnyObject)
    {
        currentTBYVal = passwordOutlet.center.y
    }
    
    @IBAction func userNameEditBegin(_ sender: AnyObject)
    {
        currentTBYVal = userNameOutlet.center.y
    }
}

