//
//  AddEventViewController.swift
//  LAB2
//
//  Created by Hackintosh on 11/19/17.
//  Copyright © 2017 Hackintosh. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddEventViewController: UIViewController {
    
    var selectedDate: Date!
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var eventTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var eventDescription: SkyFloatingLabelTextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        print(formatter.string(from: self.selectedDate))
        
        dateTimePicker.locale = Locale(identifier: "en_GB")
        dateTimePicker.setDate(self.selectedDate, animated: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addEventListener(_ sender: Any) {
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
