//
//  ViewController.swift
//  LAB2
//
//  Created by Hackintosh on 10/11/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController, UISearchBarDelegate {

    //@IBOutlet var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarWidth: NSLayoutConstraint!
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var searchBarTop: NSLayoutConstraint!
    
    @IBOutlet weak var calendarViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var calendarViewLeading: NSLayoutConstraint!
    
    
    @IBOutlet weak var monthYearTop: NSLayoutConstraint!
    @IBOutlet weak var stackCalendarViewTop: NSLayoutConstraint!
    
    @IBOutlet var mainView: UIView!
    
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
        
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBarHeight.constant = 0.076 * screenSize.height
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        monthYearTop.constant = 0.02038 * screenSize.height
        stackCalendarViewTop.constant = 0.024 * screenSize.height
        
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


    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let screenSize = UIScreen.main.bounds

        let initialPosition = searchBar.frame
        
        searchBar.layer.cornerRadius = 15
        searchBar.layer.borderColor = UIColor(red: 0, green: 0.705, blue: 0.921, alpha: 1).cgColor
//        searchBar.clipsToBounds = true
        
        let pading = 0.0241 * screenSize.width
        let trailing = self.calendarViewTrailing.constant + pading
        let leading = self.calendarViewLeading.constant + pading + trailing
        
        UIView.animate(withDuration: 1,
                       animations: {
                        searchBar.frame = CGRect(x: trailing,
                                                 y: initialPosition.minY,
                                                 width: screenSize.width - leading,
                                                 height: initialPosition.height)
        },
                       
                       completion: { finished in
                        self.updateSearchBarConstrains(trailing: trailing, width: searchBar.frame.width) })
//                        UIView.animate(withDuration: 2,
//                                       animations: {
//                        }) } )
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("***************")
    }
    
    func updateSearchBarConstrains(trailing: CGFloat, width: CGFloat) {
        searchBarWidth.constant = width
        searchBarTrailing.constant = trailing
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
        //let endDate = formatter.date(from: "2017 02 01")!                              // You can also use dates created from this function
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
