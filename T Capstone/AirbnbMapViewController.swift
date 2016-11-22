//
//  AirbnbMapViewController.swift
//  T Capstone
//
//  Created by modelf on 10/13/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AirbnbMapViewController: UIViewController {
    
    var quote: Quotes!
    
    override func viewDidLoad() {
        
        AirbnbClient.sharedInstance().browseAirbnbListing(quote) {(success, data, error) in
        print(data)
        }
        super.viewDidLoad()
        
    }
    
    
}
