//
//  AnimationUtils.swift
//  LAB2
//
//  Created by Hackintosh on 2/23/18.
//  Copyright © 2018 Hackintosh. All rights reserved.
//

import UIKit

class AnimationUtils {
    
    static func borderColorAnimation(for layer: CALayer, from fromValue: UIColor,
                                     to toValue: UIColor, withDuration duration: CFTimeInterval) {
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = fromValue.cgColor
        color.toValue = toValue.cgColor
        color.duration = duration
        color.repeatCount = 1
        layer.add(color, forKey: "borderColor")
    }
    
    static func searchBarSelect(_ searchBar: UISearchBar, to frame: CGRect) {
        let screenSize = UIScreen.main.bounds
        let pading = 0.0241 * screenSize.width
        let borderColor = UIColor(red: 0, green: 0.705, blue: 0.921, alpha: 1)
        let searchBarFrame = CGRect(x: frame.origin.x + pading,
                                    y: searchBar.frame.origin.y,
                                    width: frame.width - 2 * pading,
                                    height: searchBar.frame.height)
        animateSearchBar(searchBar, to: searchBarFrame, color: borderColor)
    }
    
    static func searchBarDeselect(_ searchBar: UISearchBar, to frame: CGRect) {
        animateSearchBar(searchBar, to: frame, color: UIColor.white)
    }
    
    static func animateSearchBar(_ searchBar: UISearchBar, to frame: CGRect, color: UIColor) {
        let borderColor = UIColor(cgColor: searchBar.layer.borderColor!)
        borderColorAnimation(for: searchBar.layer, from: borderColor,
                             to: color, withDuration: 1.5)
        UIView.animate(withDuration: 1,
                       animations: {searchBar.frame = frame},
                       completion: { finished in
                       searchBar.layer.borderColor = color.cgColor})
    }
}
