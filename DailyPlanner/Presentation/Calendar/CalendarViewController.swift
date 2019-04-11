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

class CalendarViewController: UIViewController {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        guard let validCell = view as? CalendarViewCell else { return }
        validCell.selectedView.isHidden = !cellState.isSelected
        handleTextColor(view: view, cellState: cellState)
    }
    
    func handleTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarViewCell else { return }
        let gray: CGFloat = 216 / 255
        
        let color = cellState.isSelected ? .white :
                    cellState.dateBelongsTo == .thisMonth ? .black :
                    UIColor(red: gray, green: gray, blue: gray, alpha: 1)
        
        validCell.dayLabel.textColor = color
    }
    
    func handleEvents(view: JTAppleCell?,for date: Date) {
        guard let validCell = view as? CalendarViewCell else { return }
        let keyDate = getEventKey(for: date)
        validCell.activityDot.isHidden = !events[keyDate].exists()
    }
    
    func setupPlannerViews(for date: Date, with cellState: CellState) {
        self.plannerView.date.text = cellState.text
        formatter.dateFormat = "EEEE"
        let day = formatter.string(from: date)
        self.plannerView.day.text = day
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
        let date = getEventKey(for: calendarView.selectedDates[0])
        if(!events[date].exists()) {
            events[date] = JSON([])
            let cellState = calendarView.cellStatus(for: calendarView.selectedDates[0])
            let selectedDateCell = cellState?.cell() as! CalendarViewCell
            selectedDateCell.activityDot.isHidden = false
        }
        switch self.eventState! {
        case AddEventViewController.State.ADD:
            events[date].appendArray(json: eventInfo)
            break
        case AddEventViewController.State.EDIT:
            events[date][eventToEditIndex] = eventInfo
            break
        }
        EventsUtils.cacheEvents(events)
        eventsTableView.reloadData()
    }
    
    @objc func modifyEvent(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let cell = sender.view as! EventsTableCell
            self.eventState = AddEventViewController.State.EDIT
            formatter.dateFormat = "dd-MM-yyyy"
            let selectedDate = calendarView.selectedDates[0]
            let date = formatter.string(from: selectedDate)
            for i in 0...events[date].count {
                if events[date][i]["title"].stringValue == cell.title.text! {
                    self.eventToEdit = events[date][i]
                    self.eventToEditIndex = i
                }
            }
            performSegue(withIdentifier: "AddEvent", sender: self)
        }
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        
    }
    
    func getEventKey(for date: Date) -> String {
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    func markEvent(keyDate: String, item: Int, isDone: Bool) {
        events[keyDate][item]["done"] = JSON(isDone)
        EventsUtils.cacheEvents(events)
    }
    
    func initAddEventViewController() -> AddEventViewController  {
        let vc = AddEventViewController.instantiate()
        vc.selectedDate = calendarView.selectedDates[0]
        vc.state = self.eventState!
        switch self.eventState! {
        case AddEventViewController.State.EDIT:
            vc.eventToEdit = self.eventToEdit
            break
        default:
            break
        }
        
        return vc
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        self.eventState = AddEventViewController.State.ADD
        navigationController?.pushViewController(initAddEventViewController(), animated: true)
    }
}

// MARK: Implement JTAppleCalendar Data source
extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CalendarViewCell
        cell.dayLabel.text = cellState.text
        handleTextSelected(view: cell, cellState: cellState)
        handleEvents(view: cell, for: date)
        return cell
    }

}

// MARK: Implement JTAppleCalendar Delegate
extension CalendarViewController: JTAppleCalendarViewDelegate {
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

// MARK: Implement UISearchBar Delegate
extension CalendarViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let frame = calendarStackView.convert(calendarView.frame, to: mainView)
        AnimationUtils.searchBarSelect(searchBar, to: frame)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        AnimationUtils.searchBarDeselect(searchBar, to: initialSearchBarFrame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: Implement UITableView Data source for planner view
extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard calendarView.selectedDates.count > 0 else {
            return 0
        }
        let keyDate = getEventKey(for: calendarView.selectedDates[0])
        
        return events[keyDate].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "cell")!
        
        return cell
    }


}

// MARK: Implement UITableView delegate for planner view
extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let eventCell = cell as! EventsTableCell
        let keyDate = getEventKey(for: calendarView.selectedDates[0])
        
        eventCell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action:  #selector(modifyEvent(sender:))))
        eventCell.keyDate = keyDate
        eventCell.item = indexPath.item
        eventCell.addCheckBoxListener(self.markEvent)
        eventCell.title.text = events[keyDate][indexPath.item]["title"].stringValue
        eventCell.checkBox.on = events[keyDate][indexPath.item]["done"].boolValue
        eventCell.checkBox.reload()
    }
}

extension JSON {
    
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
