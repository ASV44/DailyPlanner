//
//  AddEventViewController.swift
//  DailyPlanner
//
//  Created by Alexandr Vdovicenco on 11/19/17.
//  Copyright © 2017 Alexandr Vdovicenco. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import UserNotifications

class AddEventViewController: UIViewController, StoryboardInstantiable, UITextFieldDelegate {

    static let storyboardName = "AddEvent"

    @IBOutlet var dateTimePicker: UIDatePicker!
    @IBOutlet var eventTitle: SkyFloatingLabelTextField!
    @IBOutlet var eventDescription: SkyFloatingLabelTextField!
    @IBOutlet var addEventButton: UIButton!

    var interactor: AddEventInteractor!
    var selectedDate: Date!
    var event: Event!

    override func viewDidLoad() {
        self.title = "Add Your Event"
        super.viewDidLoad()
        setupDateTimePicker()
        setUpView()
        // TODO: delete old notification when event is edited
    }

    func setupDateTimePicker() {
        dateTimePicker.locale = Locale(identifier: "en_GB")
        dateTimePicker.minimumDate = self.selectedDate
        dateTimePicker.maximumDate = Date.setTime(of: selectedDate, hour: 23, minute: 59)
    }

    func setUpView() {
        eventTitle.text! = event?.title ?? .empty
        eventDescription.text! = event?.description ?? .empty
        dateTimePicker.setDate(event?.date ?? Date(), animated: false)
        addEventButton.setTitle("Edit", for: UIControl.State.normal)
    }

    @IBAction func addButtonClick(_ sender: Any) {
        event = Event(date: dateTimePicker.date, title: eventTitle.text!, description: eventDescription.text!)
        registerNotification()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func registerNotification() {
        createDelayedNotification()
    }

    @available(iOS 10.0, *)
    func createDelayedNotification() {
        let content = UNMutableNotificationContent()
        content.title = eventTitle.text!
        content.body = eventDescription.text!
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "clockAlarm.caf"))
        let components = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year],
                                                         from: dateTimePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = "localNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { _ in })
    }
}
