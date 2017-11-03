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

    //@IBOutlet var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let screenSize = UIScreen.main.bounds
        print(screenSize)
        date.font = date.font.withSize(screenSize.width * 0.12)
        day.font = day.font.withSize(screenSize.width * 0.0483)
        
        setupCalendar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCalendar() {        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates() { visibleDates in
            self.setupViewOfCalendar(from: visibleDates)
        }
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
    }
    
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        
        //print(month, year)
        monthYearLabel.text = month + " " + year
    }
    
    func handleTextSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CellView else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        }
        else {
            validCell.selectedView.isHidden = true
        }
        handleTextColor(view: view, cellState: cellState)
    }
    
    func handleTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CellView else { return }
        
        if cellState.isSelected {
            validCell.dayLabel.textColor = .white
        }
        else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dayLabel.textColor = .black
            }
            else {
                validCell.dayLabel.textColor = UIColor(red: 0.9176, green: 0.9176, blue: 0.9176, alpha: 1)
            }
        }
    }
    
    func setupPlannerViews(for date: Date, with cellState: CellState) {
        self.date.text = cellState.text
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date)
        self.day.text = day
    }

}

extension ViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        //configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        cell.dayLabel.text = cellState.text
        handleTextSelected(view: cell, cellState: cellState)
        
        return cell
    }

}

extension ViewController: JTAppleCalendarViewDelegate {
    //Display cell
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2016 02 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2017 02 01")!                              // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: Date(),
                                                 firstDayOfWeek: .monday)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleTextSelected(view: cell, cellState: cellState)
        setupPlannerViews(for: date, with: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleTextSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
    }
}
