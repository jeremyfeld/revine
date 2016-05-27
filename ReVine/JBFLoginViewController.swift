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
//        self.loginButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginButtonTapped(sender: AnyObject)
    {
        var loginDictionary: [String: String] = ["username": self.emailTextField.text!, "password": self.passwordTextField.text!]
        print("\(loginDictionary)")
        JBFVineClient.sharedDataStore().loginWithUserDictionary(loginDictionary)
        
        
    }
    
    func enableLoginButton()
    {
        var validEmail: Bool = false
        var validPassword: Bool = false
        if let emailText = self.emailTextField.text {
            validEmail = true
        }
        
        if let passwordText = self.passwordTextField.text {
            validPassword = true
        }
        
        if validEmail && validPassword {
            self.loginButton.enabled = true
        }
    }
}
