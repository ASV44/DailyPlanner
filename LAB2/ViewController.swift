//
//  ViewController.swift
//  LAB2
//
//  Created by Hackintosh on 10/11/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftyJSON
import UserNotifications

class ViewController: UIViewController, UISearchBarDelegate {

    //@IBOutlet var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var calendarStackView: UIStackView!
    
    let formatter = DateFormatter()
    
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var plannerView: PlannerView!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var plannerStackView: UIStackView!
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var events: JSON!
    
    var initialSearchBarFrame: CGRect!
    
    var eventState: AddEventViewController.State!
    var eventToEdit: JSON!
    var eventToEditIndex: Int!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait)
    }
    
    // TODO: Refactor everything, this is a very bad code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
        setupSearchBar()
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        events = EventsUtils.getCachedEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppUtility.lockOrientation(.all)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        mainView.translatesAutoresizingMaskIntoConstraints = false
        initialSearchBarFrame = searchBar.frame
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
        validCell.selectedView.isHidden = !cellState.isSelected
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
                let gray: CGFloat = 216 / 255
                validCell.dayLabel.textColor = UIColor(red: gray, green: gray, blue: gray, alpha: 1)
            }
        }
    }
    
    func setupPlannerViews(for date: Date, with cellState: CellState) {
        self.plannerView.date.text = cellState.text
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date)
        self.plannerView.day.text = day
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let screenSize = UIScreen.main.bounds
        
        let borderColor = UIColor(red: 0, green: 0.705, blue: 0.921, alpha: 1)
        borderColorAnimation(for: searchBar.layer, from: UIColor.white, to: borderColor, withDuration: 3)
                
        let frame = calendarStackView.convert(calendarView.frame, to: mainView)
        
        let pading = 0.0241 * screenSize.width

        UIView.animate(withDuration: 1,
                       animations: {
                        searchBar.frame = CGRect(x: frame.origin.x + pading,
                                                 y: searchBar.frame.origin.y,
                                                 width: frame.width - 2 * pading,
                                                 height: searchBar.frame.height)},
                       completion: { finished in
                        searchBar.layer.borderColor = borderColor.cgColor})
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let borderColor = UIColor(red: 0, green: 0.705, blue: 0.921, alpha: 1)
        borderColorAnimation(for: searchBar.layer, from: borderColor, to: UIColor.white, withDuration: 1.5)
        
        UIView.animate(withDuration: 1,
                       animations: {searchBar.frame = self.initialSearchBarFrame},
                       completion: { finished in
                        searchBar.layer.borderColor = UIColor.white.cgColor})
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func borderColorAnimation(for layer: CALayer, from fromValue: UIColor,
                              to toValue: UIColor, withDuration duration: CFTimeInterval) {
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = fromValue.cgColor
        color.toValue = toValue.cgColor
        color.duration = duration
        color.repeatCount = 1
        layer.add(color, forKey: "borderColor")
    }
    
    @IBAction func addButtonListener(_ sender: Any) {
        self.eventState = AddEventViewController.State.ADD
        self.performSegue(withIdentifier: "AddEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEvent" {
            let vc = segue.destination as! AddEventViewController
            vc.selectedDate = calendarView.selectedDates[0]
            vc.state = self.eventState!
            switch self.eventState! {
            case AddEventViewController.State.EDIT:
                vc.eventToEdit = self.eventToEdit
                break
            default:
                break
            }
        }
    }
    
    @IBAction func getEventData(for segue: UIStoryboardSegue) {
        if segue.identifier == "addNewEvent"{
            let vc = segue.source as! AddEventViewController
            //print(vc.eventInfo)
            addNewEvent(vc.eventInfo)
        }
    }
    
    func addNewEvent(_ eventInfo: JSON) {
        formatter.dateFormat = "dd-MM-yyyy"
        let selectedDate = calendarView.selectedDates[0]
        let date = formatter.string(from: selectedDate)
        if(!events[date].exists()) {
            events[date] = JSON([])
            let selectedDateCell = calendarView.cellStatus(for: selectedDate)?.cell() as! CellView
            selectedDateCell.activityDot.isHidden = false
        }
        switch self.eventState! {
        case AddEventViewController.State.ADD:
            events[date].appendArray(json: eventInfo)
            break
        case AddEventViewController.State.EDIT:
            events[date][eventToEditIndex] = eventInfo
            break
        default:
            break
        }
        print(events)
        EventsUtils.cacheEvents(events)
        eventsTableView.reloadData()
    }
    
    @objc func labelOnCLick(sender:UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let label = sender.view as! UILabel
            self.eventState = AddEventViewController.State.EDIT
            formatter.dateFormat = "dd-MM-yyyy"
            let selectedDate = calendarView.selectedDates[0]
            let date = formatter.string(from: selectedDate)
            for i in 0...events[date].count {
                if events[date][i]["title"].stringValue == label.text! {
                    self.eventToEdit = events[date][i]
                    self.eventToEditIndex = i
                }
            }
            performSegue(withIdentifier: "AddEvent", sender: self)
        }
        else if sender.state == .began {
            
        }
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        
    }
}

extension ViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        cell.dayLabel.text = cellState.text
        handleTextSelected(view: cell, cellState: cellState)
        
        return cell
    }

}

extension ViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
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
        searchBar.endEditing(true)
        eventsTableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleTextSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates)
        searchBar.endEditing(true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard calendarView.selectedDates.count > 0 else {
            return 0
        }
        formatter.dateFormat = "dd-MM-yyyy"
        let keyDate = formatter.string(from: calendarView.selectedDates[0])
        
        return events[keyDate].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.eventsTableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!

        return cell
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let eventCell = cell as! EventsTableCell
        formatter.dateFormat = "dd-MM-yyyy"
        let keyDate = formatter.string(from: calendarView.selectedDates[0])
        
        eventCell.title.text = events[keyDate][indexPath.item]["title"].stringValue
    }
}

extension JSON{
    mutating func appendArray(json:JSON){
        if var arr = self.array{
            arr.append(json)
            self = JSON(arr);
        }
    }
    
    mutating func appendDictionary(key:String,json:JSON){
        if var dict = self.dictionary{
            dict[key] = json;
            self = JSON(dict);
        }
    }
}
