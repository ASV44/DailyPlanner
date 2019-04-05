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
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var day: UILabel!
    
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
        date.font = date.font.withSize(screenSize.width * 0.12)
        day.font = day.font.withSize(screenSize.width * 0.0483)
    }
    
}
