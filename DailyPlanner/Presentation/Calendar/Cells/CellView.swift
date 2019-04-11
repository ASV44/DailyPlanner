//
//  CellView.swift
//  LAB2
//
//  Created by Hackintosh on 10/22/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import Foundation
import JTAppleCalendar

class CellView: JTAppleCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var activityDot: UIView!
    
    @IBOutlet weak var selectedViewWidth: NSLayoutConstraint!
    @IBOutlet weak var selectedVIewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var activityDotWidth: NSLayoutConstraint!
    @IBOutlet weak var activityDotHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        dayLabel.font = dayLabel.font.withSize(0.041 * screenSize.width)
        selectedViewWidth.constant =  0.0724 * screenSize.width
        selectedVIewHeight.constant = 0.0407 * screenSize.height
        selectedView.layer.cornerRadius = 0.02038 * screenSize.height
        
        activityDot.isHidden = true
        activityDotWidth.constant = 0.012 * screenSize.width
        activityDotHeight.constant = activityDotWidth.constant
        activityDot.layer.cornerRadius = activityDotWidth.constant / 2
    }
}
