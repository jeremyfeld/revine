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
        
        loginButton.layer.cornerRadius = 5
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        let loginParams: [String: String] = ["username": self.emailTextField.text!, "password": self.passwordTextField.text!]
        
        JBFVineClient.sharedClient().loginWithUserParams(loginParams) { (loggedIn, error) in
            
            if (loggedIn) {
                self.performSegueWithIdentifier("segueToTimeline", sender: self)
                
            } else {
                
                if error != nil {
                    let controller = UIAlertController.alertControllerWithTitle("Oops!", message: "There was an error logging in: \(error.localizedDescription)")
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                } else {
                let controller = UIAlertController.alertControllerWithTitle("Oops!", message: "There was an error logging in.")
                
                self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        }
    }
}