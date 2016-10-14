//
//  MapViewFilterViewController.swift
//  T Capstone
//
//  Created by modelf on 10/11/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class MapViewFilterViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var buttonShowHide: UIButton!
    
    @IBOutlet weak var departureView: UIView!
    @IBOutlet weak var arrivalView: UIView!
    
    @IBAction func dismiss(sender: AnyObject) {
        
        self.dismiss(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        
        departureView.isHidden = true
        
        datePicker.center.y -= view.bounds.height
    }
    
    @IBAction func showOrHideArrivalView(_ sender: AnyObject) {
        if departureView.isHidden == true {
            UIView.animate(withDuration: 1.0, animations: {
                self.departureView.frame.origin.y += self.departureView.frame.height
                
                self.departureView.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.departureView.frame.origin.y -= self.departureView.frame.height
                self.departureView.isHidden = true
            })
        }
    }

}


