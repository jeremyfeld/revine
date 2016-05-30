//
//  JBFLoginViewController.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit

class JBFLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        var loginDictionary: [String: String] = ["username": self.emailTextField.text!, "password": self.passwordTextField.text!]
        
        JBFVineClient.sharedClient().loginWithUserDictionary(loginDictionary) { (loggedIn) in
            
            if (loggedIn) {
                
                self.performSegueWithIdentifier("segueToTimeline", sender: self)
                
            } else {
                
                let controller = UIAlertController.alertControllerWithTitle("Error", message: "There was an error logging in.")
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }
}
