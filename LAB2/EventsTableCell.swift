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
    
    private var checkBoxListener: ((String, Int, Bool) -> ())!
    
    var keyDate: String!
    var item: Int!
    
    override func awakeFromNib() {
        checkBox.delegate = self
        checkBox.onAnimationType = .bounce
        checkBox.offAnimationType = .bounce
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        bgColorView.layer.cornerRadius = 10
        bgColorView.layer.borderColor = UIColor.white.cgColor
        bgColorView.layer.borderWidth = 1.5
        selectedBackgroundView = bgColorView
    }
    
    func addCheckBoxListener(_ listener: @escaping (String, Int, Bool) -> ()) {
        self.checkBoxListener = listener
    }
}

//MARK: Implement check box delegate
extension EventsTableCell: BEMCheckBoxDelegate {
    
    func didTap(_ checkBox: BEMCheckBox) {
        checkBoxListener(keyDate, item, checkBox.on)
    }
}
