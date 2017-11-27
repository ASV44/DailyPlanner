//
//  AddEventViewController.swift
//  LAB2
//
//  Created by Hackintosh on 11/19/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class AddEventViewController: UIViewController {
    
    var selectedDate: Date!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var eventTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var eventDescription: SkyFloatingLabelTextField!
    
    let formatter: DateFormatter = DateFormatter()
    
    var eventInfo = JSON()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        print(formatter.string(from: self.selectedDate))
        setCurrentTime()
        dateTimePicker.locale = Locale(identifier: "en_GB")
        dateTimePicker.minimumDate = self.selectedDate
        dateTimePicker.maximumDate = setTimeOfDate(selectedDate, hour: 23, minute: 59)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func addEventListener(_ sender: Any) {
        formatter.dateFormat = "HH:mm"
        let date = dateTimePicker.date
        eventInfo["time"] = JSON(formatter.string(from: date))
        eventInfo["title"] = JSON(eventTitle.text!)
        eventInfo["description"] = JSON(eventDescription.text!)

        self.backToCalendar(self)
    }
    
    @IBAction func backToCalendar(_ sender: Any) {
        performSegue(withIdentifier: "backToCalendar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToCalendar"{
            let vc = segue.destination as! ViewController
            vc.mainView.translatesAutoresizingMaskIntoConstraints = true
        }
    }
}
