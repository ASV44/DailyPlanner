//
//  ViewController.swift
//  LAB2
//
//  Created by Hackintosh on 10/11/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit
import JTAppleCalendar
import UserNotifications

class CalendarViewController: UIViewController {
    @IBOutlet var date: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var calendarStackView: UIStackView!
    @IBOutlet var monthYearLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var plannerView: PlannerView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var plannerStackView: UIStackView!
    @IBOutlet var eventsTableView: UITableView!

    var presenter: CalendarPresenter =  CalendarPresenter()
    var calendarEvents: EventListing!
    var initialSearchBarFrame: CGRect!
    var eventToEdit: Event!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }

    // TODO: Refactor everything, this is a very bad code

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setupSearchBar()
        setupPlannerView()
        
        calendarEvents = EventListing().restore()
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
        calendarView.visibleDates(setupViewOfCalendar)
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
    }

    func setupSearchBar() {
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        initialSearchBarFrame = searchBar.frame
    }

    func setupPlannerView() {
        eventsTableView.register(EventsTableCell.self)
    }

    func setupViewOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        let year = presenter.formatter.string(.year, from: date)
        let month = presenter.formatter.string(.monthName, from: date)
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
        validCell.activityDot.isHidden = calendarEvents.eventsList(for: date).isEmpty
    }

    func setupPlannerViews(for date: Date, with cellState: CellState) {
        self.plannerView.date.text = cellState.text
        let day = presenter.formatter.string(.dayName, from: date)
        self.plannerView.day.text = day
    }

    @objc func modifyEvent(sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let cell = sender.view as! EventsTableCell
            let date = calendarView.selectedDates[0]
        }
    }

    @IBAction func settingsButton(_ sender: Any) {

    }

    func markEvent(date: Date, item: Int, isDone: Bool) {
//        calendarEvents.eventsList(for: date)[item].isCompleted = true
        calendarEvents.persist()
    }

    func initAddEventViewController() -> AddEventViewController  {
        let vc = AddEventViewController.instantiate()
        vc.interactor = AddEventInteractor()
        vc.selectedDate = calendarView.selectedDates[0]

        return vc
    }

    @IBAction func addEvent(_ sender: UIButton) {
        navigationController?.pushViewController(initAddEventViewController(), animated: true)
    }
}

extension CalendarViewController: CalendarView {
    func updatePlannedEventsView() {
        let date = calendarView.selectedDates[0]
        if(calendarEvents.eventsList(for: date).isEmpty) {
            let cellState = calendarView.cellStatus(for: calendarView.selectedDates[0])
            let selectedDateCell = cellState?.cell() as! CalendarViewCell
            selectedDateCell.activityDot.isHidden = false
        }
        eventsTableView.reloadData()
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
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell,
                  forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }

    //Display cell
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = presenter.formatter.date(.yearMonthDate, from: "2016 02 01") // You can use date generated from a formatter
        let endDate = presenter.formatter.date(.yearMonthDate, from: "2025 12 31")  // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
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
        guard calendarView.selectedDates.count > 0 else { return 0 }
        return calendarEvents.eventsList(for: calendarView.selectedDates[0]).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(EventsTableCell.self, for: indexPath)
        cell.populate(with: EventsTableCellData(event: calendarEvents.eventsList(for: Date())[indexPath.row],
                                                checkAction: { _, _, _ in }))
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

        eventCell.addGestureRecognizer(UILongPressGestureRecognizer(target: self,
                                                                    action:  #selector(modifyEvent(sender:))))
    }
}
