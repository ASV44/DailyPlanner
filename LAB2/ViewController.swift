//
//  ViewController.swift
//  LAB2
//
//  Created by Hackintosh on 10/11/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {

    @IBOutlet var calendarView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        calendarView.dataSource = self
//        calendarView.delegate = self
//        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        //configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        myCustomCell.dayLabel.text = cellState.text
        return myCustomCell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2017 02 01")!                              // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate)
//                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
//            calendar: Calendar.current,
//            generateInDates: .forAllMonths,
//            generateOutDates: .tillEndOfGrid,
//            firstDayOfWeek: .sunday)
        return parameters
    }
    
//    func configureVisibleCell(myCustomCell: CellView, cellState: CellState, date: Date) {
//        myCustomCell.dayLabel.text = cellState.text
//        if testCalendar.isDateInToday(date) {
//            myCustomCell.backgroundColor = red
//        } else {
//            myCustomCell.backgroundColor = white
//        }
//
//        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
//
//
//        if cellState.text == "1" {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM"
//            let month = formatter.string(from: date)
//            myCustomCell.monthLabel.text = "\(month) \(cellState.text)"
//        } else {
//            myCustomCell.monthLabel.text = ""
//        }
//    }
}
