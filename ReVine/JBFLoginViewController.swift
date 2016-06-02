//
//  JBFLoginViewController.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/26/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import UIKit
import pop

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
    
    @IBAction func emailEditingDidEnd(sender: AnyObject) {
        
        if (emailTextField.text?.characters.count)! < 3 || !(emailTextField.text?.characters.contains("@"))! {
           animateTextField(emailTextField)
        }
    }
    
    @IBAction func passwordEditingDidEnd(sender: AnyObject) {
        
        if (passwordTextField.text?.characters.count)! < 6 {
            animateTextField(passwordTextField)
        }
    }
    
    func animateTextField(textField:UITextField) {

        let shake =  POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        shake.springBounciness = 20
        shake.velocity = NSNumber(int: 2500)
        shake.removedOnCompletion = true
        textField.layer.pop_addAnimation(shake, forKey: "shakeAnimation")

    }
}