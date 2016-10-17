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
    
    
    var isDepartureMenuOpen = false
    var isReturnMenuOpen = false
    
    @IBOutlet weak var departDatePicker: UIDatePicker!
    @IBOutlet weak var departButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var departDateBottom: NSLayoutConstraint!
    @IBOutlet weak var departButton: UIButton!
    
    @IBOutlet weak var returnDatePicker: UIDatePicker!
    @IBOutlet weak var returnButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnDatePicker.center.y += view.frame.height
        
        departDatePicker.center.x -= view.frame.width
    }
    
    
    @IBAction func showDepartureMenu (_ sender: AnyObject) {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            self.isDepartureMenuOpen = !self.isDepartureMenuOpen
            self.departDateBottom.constant = self.isDepartureMenuOpen ? self.departDatePicker.frame.height : 31.0
            self.departButtonBottom.constant = self.isDepartureMenuOpen ? self.departDatePicker.frame.height : 31.0
            if self.isReturnMenuOpen {
                self.returnDatePicker.center.y = self.isDepartureMenuOpen ? self.returnDatePicker.center.y + self.departDatePicker.frame.height : self.returnDatePicker.center.y - self.departDatePicker.frame.height
            }
            let angle = self.isDepartureMenuOpen ? CGFloat(M_PI_4) : 0.0
            self.departButton.transform = CGAffineTransform(rotationAngle: angle)
            if self.isDepartureMenuOpen {
                self.departDatePicker.center.x += self.view.frame.width
            } else {
                self.departDatePicker.center.x -= self.view.frame.width
            }
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        
        
    }
    
    @IBAction func showReturnMenu (_ sender: AnyObject) {
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            self.isReturnMenuOpen = !self.isReturnMenuOpen
            let angle = self.isReturnMenuOpen ? CGFloat(M_PI_4) : 0.0
            self.returnButton.transform = CGAffineTransform(rotationAngle: angle)
            if self.isReturnMenuOpen {
                if self.departDatePicker.center.x > 0 {
                    self.returnDatePicker.center.y = self.departDatePicker.center.y + 200
                }
                else {
                    self.returnDatePicker.center.y = 300
                }
            } else {
                self.returnDatePicker.center.y += self.view.frame.height
            }
    
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        
        self.dismiss(animated: true)
        
    }
    
    
}


