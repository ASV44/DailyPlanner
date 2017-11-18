//
//  DateViewController.swift
//  LAB2
//
//  Created by Hackintosh on 11/1/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit

class PlannerView: UIView {
    
    private let gradient : CAGradientLayer = CAGradientLayer()
    
    @IBOutlet weak var addButton : UIButton!
    
    @IBOutlet weak var addButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var addButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var dateTop: NSLayoutConstraint!
    @IBOutlet weak var dayTop: NSLayoutConstraint!
    
    override func draw(_ rect: CGRect) {
        self.gradient.frame = self.bounds
        self.gradient.colors = [UIColor(red: 0.0078, green: 0.8, blue: 0.952, alpha: 1).cgColor, //UIColor.blue.cgColor]
                                UIColor(red: 0, green: 0.5, blue: 0.9 , alpha: 1).cgColor]
        
        if self.gradient.superlayer == nil {
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        addButtonBottom.constant = 0.0398 * screenSize.height
        addButtonTrailing.constant = 0.0579 * screenSize.width
        dateTop.constant = 0.0271 * screenSize.height
        dayTop.constant = 0.00995 * screenSize.height
    }
}
