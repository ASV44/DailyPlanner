//
//  AddEventViewController.swift
//  DailyPlanner
//
//  Created by Hackintosh on 11/19/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
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

    var eventToEdit: Event!
    var state: EventState!

    override func viewDidLoad() {
        self.title = "Add Your Event"
        super.viewDidLoad()
        setupDateTimePicker()
        setCurrentTime()

        if state == .EDIT {
            // TODO: delete old notification when event is edited
            eventTitle.text! = eventToEdit.title
            eventDescription.text! = eventToEdit.description
            dateTimePicker.setDate(eventToEdit.date, animated: false)
            addEventButton.setTitle("Edit", for: UIControl.State.normal)
        }
    }

    func setupDateTimePicker() {
        dateTimePicker.locale = Locale(identifier: "en_GB")
        dateTimePicker.minimumDate = self.selectedDate
        dateTimePicker.maximumDate = setTimeOfDate(selectedDate, hour: 23, minute: 59)
    }

    func setupEventUIElements() {
        eventTitle.delegate = self
        eventDescription.delegate = self
        eventTitle.returnKeyType = UIReturnKeyType.done
        eventDescription.returnKeyType = UIReturnKeyType.done
    }

    func setCurrentTime() {
        let calendar = Calendar.current
        let currentTime = calendar.dateComponents([.hour, .minute], from: Date())
        let dateWithCurrentTime = setTimeOfDate(selectedDate, hour: currentTime.hour!, minute: currentTime.minute!)
        dateTimePicker.setDate(dateWithCurrentTime, animated: false)
    }

    func setTimeOfDate(_ date: Date, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var comp = calendar.dateComponents(in: TimeZone.current, from: date)
        comp.hour = hour
        comp.minute = minute

        return calendar.date(from: comp)!
    }

    @IBAction func addButtonClick(_ sender: Any) {
        event = Event(date: dateTimePicker.date, title: eventTitle.text!, description: eventDescription.text!)
        showAlert()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func showAlert() {
        if #available(iOS 10.0, *) {

            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound];

            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
            }

            let content = UNMutableNotificationContent()
            content.title = eventTitle.text!
            content.body = eventDescription.text!
            content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("clockAlarm.caf"))

            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .day, .month, .year], from: dateTimePicker.date)
            print(components)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            print(trigger.dateComponents)

            let identifier = "localNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
                if error != nil {
                    // Something went wrong
                }
            })

        }
        else {

            // ios 9

            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()

            _ = UILocalNotification()
//            notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval(delay)) as Date
//            notification.alertBody = "Nottification with Delay"
//            notification.alertAction = "This notification has \(delay) second delay"
//            notification.soundName = UILocalNotificationDefaultSoundName
//            UIApplication.shared.scheduleLocalNotification(notification)

        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
