//
//  EventsTableCell.swift
//  LAB2
//
//  Created by Hackintosh on 2/22/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit
import BEMCheckBox

class EventsTableCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    override func awakeFromNib() {
        checkBox.onAnimationType = .bounce
        checkBox.offAnimationType = .bounce
    }
}
