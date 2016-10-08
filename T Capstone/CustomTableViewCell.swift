//
//  CustomTableViewCell.swift
//  T Capstone
//
//  Created by modelf on 10/5/16.
//  Copyright © 2016 modelf. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var flightDate: UILabel!
    @IBOutlet weak var minPrice: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
