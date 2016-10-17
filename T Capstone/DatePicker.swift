//
//  DatePicker.swift
//  T Capstone
//
//  Created by modelf on 10/16/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class DatePicker: UIDatePicker {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implimented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init (inView: UIView) {
        let rect = CGRect(x: inView.bounds.width, y: 200.0, width: inView.frame.width, height: 200.0)
        self.init(frame: rect)
    
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil {
            return
        }
    }
}
