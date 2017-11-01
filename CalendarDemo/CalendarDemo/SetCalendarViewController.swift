//
//  SetCalendarViewController.swift
//  CalendarDemo
//
//  Created by iOS Dev on 01/11/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import UIKit

class SetCalendarViewController: UIViewController {

    @IBOutlet weak var textStartDate: UITextField!
    @IBOutlet weak var textEndDate: UITextField!
    @IBOutlet weak var buttonGenerateCalendar: UIButton!
    
    weak var delegate: SetCalendarViewControllerDelegate?
    
    var endDateString:String = ""
    var startDateString:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textStartDate.becomeFirstResponder()
    }
    
    func setupView() {
        self.textStartDate.delegate = self
        self.textEndDate.delegate = self
        self.textStartDate.inputView = self.returnTimeInputView(Date(), tag: 1)
        self.textEndDate.inputView = self.returnTimeInputView(Date(), tag: 2)
    }

    @IBAction func generateCalendarButtonAction(_ sender: UIButton) {
        if self.startDateString.characters.count > 0 && self.endDateString.characters.count > 0 {
            self.dismiss(animated: true, completion: {
                self.delegate?.generateCalendarButtonTapped(startDateStr: self.startDateString, endDateStr: self.endDateString)
            })
        } else {
            debugPrint("Please select start date and end date")
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func returnTimeInputView(_ minimumDate: Date, tag:Int) -> UIDatePicker {
        let timePickerView  : UIDatePicker = UIDatePicker()
        timePickerView.datePickerMode = UIDatePickerMode.date
        if tag == 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from: startDateString) {
                timePickerView.date = date
            }
            timePickerView.addTarget(self, action: #selector(handleStartTimePicker(_:)), for: UIControlEvents.valueChanged)
        } else {
            if let minDate = TimeUtility.getDateFromString(dateString: self.startDateString, dateFormat: dateFormat) {
                timePickerView.minimumDate = minDate
                timePickerView.date = minDate
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            if let date = dateFormatter.date(from: endDateString) {
                timePickerView.date = date
            }
            
            timePickerView.addTarget(self, action: #selector(handleEndTimePicker(_:)), for: UIControlEvents.valueChanged)
        }
        
        return timePickerView
    }
    
    @objc func handleStartTimePicker(_ sender: UIDatePicker) {
        startDateString = TimeUtility.getStringFromDate(date: sender.date, dateFormat: dateFormat)
        self.textStartDate.text = startDateString
    }
    
    
    @objc func handleEndTimePicker(_ sender: UIDatePicker) {
        endDateString = TimeUtility.getStringFromDate(date: sender.date, dateFormat: dateFormat)
        self.textEndDate.text = endDateString
    }
    
}

extension SetCalendarViewController: UITextFieldDelegate {
    // MARK: UITextField's Delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textStartDate {
            if startDateString.isEmpty {
                startDateString = TimeUtility.getStringFromDate(date: Date(), dateFormat: dateFormat)
            }
        } else if textField == self.textEndDate {
            if startDateString.isEmpty{
                self.textStartDate.becomeFirstResponder()
            } else {
                if endDateString.isEmpty {
                    self.endDateString = self.startDateString
                }
            }
        }
        return true
    }
    
}


protocol SetCalendarViewControllerDelegate: class {
    func generateCalendarButtonTapped(startDateStr: String, endDateStr: String)
}

