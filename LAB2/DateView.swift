//
//  DateViewController.swift
//  LAB2
//
//  Created by Hackintosh on 11/1/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit

class DateView: UIView {
    
    private let gradient : CAGradientLayer = CAGradientLayer()
    
    
    override func draw(_ rect: CGRect) {
        self.gradient.frame = self.bounds
        self.gradient.colors = [UIColor(red: 0.0078, green: 0.8, blue: 0.952, alpha: 1).cgColor, //UIColor.blue.cgColor]
                                UIColor(red: 0, green: 0.6, blue: 0.9 , alpha: 1).cgColor]
//        self.gradient.startPoint = CGPoint.init(x: 0, y: 0)
//        self.gradient.endPoint = CGPoint.init(x: 0, y: 1)
        if self.gradient.superlayer == nil {
            self.layer.insertSublayer(self.gradient, at: 0)
        }
    }
}
