//
//  EventsTableCell.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 2/22/18.
//  Copyright © 2018 Alexandr Vdovicenco. All rights reserved.
//

import UIKit
import BEMCheckBox

class EventsTableCell: UITableViewCell, NibLoadable {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    private var checkBoxAction: ((String, Int, Bool) -> ())?
    
    var event: Event!
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
    
    func addCheckBoxListener(_ action: @escaping (String, Int, Bool) -> ()) {
        checkBoxAction = action
    }
}

//MARK: Implement Populatable protocol
extension EventsTableCell: Populatable {
    func populate<T>(with data: T) {
        guard let data = data as? EventsTableCellData else { return }
                event = data.event
                checkBoxAction = data.checkAction
                title.text = event.title
                checkBox.on = event.isCompleted
                checkBox.reload()
        //        eventCell.item = indexPath.item
    }
}

//MARK: Implement check box delegate
extension EventsTableCell: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
//        checkBoxAction(keyDate, item, checkBox.on)
    }
}
