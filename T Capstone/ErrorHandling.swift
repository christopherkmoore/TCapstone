//
//  ErrorHandling.swift
//  T Capstone
//
//  Created by modelf on 10/7/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandling: NSObject {
    
    static func displayError (_ vc: UIViewController, error: String?) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {(paramAction: UIAlertAction!) in
                print(paramAction.title!)})
            
            alertController.addAction(action)
            vc.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}
