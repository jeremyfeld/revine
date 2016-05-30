//
//  UIAlertController+Convenience.swift
//  ReVine
//
//  Created by Jeremy Feld on 5/30/16.
//  Copyright © 2016 JBF. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func alertControllerWithTitle(title:String, message:String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        return alertController
    }  
}