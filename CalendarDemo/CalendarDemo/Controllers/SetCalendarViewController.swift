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
    
    var activeTextField: UITextField?
    
    weak var delegate: SetCalendarViewControllerDelegate?
    
    var endDateString:String = ""
    var startDateString:String = ""
    
    var startDateAccessoryView : InputAccessoryView?
    var endDateAccessoryView : InputAccessoryView?
    
    
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
        self.initialiseInputAccessoryView()
        self.textStartDate.inputView = self.returnTimeInputView(1)
        self.textEndDate.inputView = self.returnTimeInputView(2)
        
        if self.startDateString.characters.count > 0 {
            self.textStartDate.text = self.startDateString
        }
        
        if self.endDateString.characters.count > 0 {
            self.textEndDate.text = self.endDateString
        }
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
    
    func initialiseInputAccessoryView(){
        self.textStartDate.delegate = self
        
        startDateAccessoryView = InputAccessoryView.instanceFromNib()
        if startDateAccessoryView != nil {
            startDateAccessoryView?.previousButton.isHidden = true
            startDateAccessoryView?.widthPreviousButton.constant = 0
            
            startDateAccessoryView?.warningLabel.text = ""
            
            startDateAccessoryView?.nextButton.setTitle("Next", for: UIControlState())
            startDateAccessoryView?.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
            startDateAccessoryView?.frame = CGRect(x: startDateAccessoryView!.frame.origin.x, y: startDateAccessoryView!.frame.origin.y, width: self.view.frame.size.width, height: startDateAccessoryView!.frame.size.height)
            self.textStartDate.inputAccessoryView = startDateAccessoryView!
        }
        
        
        self.textEndDate.delegate = self
        
        endDateAccessoryView = InputAccessoryView.instanceFromNib()
        if endDateAccessoryView != nil {
            endDateAccessoryView?.previousButton.setTitle("Previous", for: UIControlState())
            endDateAccessoryView?.previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
            
            endDateAccessoryView?.nextButton.setTitle("Done", for: UIControlState())
            endDateAccessoryView?.nextButton.addTarget(self, action: #selector(inputToolbarDonePressed), for: .touchUpInside)
            
            endDateAccessoryView?.warningLabel.text = ""
            
            endDateAccessoryView?.frame = CGRect(x: endDateAccessoryView!.frame.origin.x, y: endDateAccessoryView!.frame.origin.y, width: self.view.frame.size.width, height: endDateAccessoryView!.frame.size.height)
            self.textEndDate.inputAccessoryView = endDateAccessoryView!
        }
        
    }
    
    @objc func nextButtonPressed() {
        self.textEndDate.becomeFirstResponder()
    }
    
    @objc func previousButtonPressed() {
        self.textStartDate.becomeFirstResponder()
    }
    
    @objc func inputToolbarDonePressed() {
        self.textEndDate.resignFirstResponder()
    }
    
    func returnTimeInputView(_ tag:Int) -> UIDatePicker {
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
            } else {
                timePickerView.minimumDate = Date()
                timePickerView.date = Date()
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
            if startDateString.isEmpty {
                self.textStartDate.becomeFirstResponder()
            } else {
                if endDateString.isEmpty {
                    self.endDateString = self.startDateString
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textStartDate {
            self.textStartDate.inputView = nil
            self.textStartDate.inputView = self.returnTimeInputView(1)
        } else if textField == self.textEndDate {
            self.textEndDate.inputView = nil
            self.textEndDate.inputView = self.returnTimeInputView(2)
        }
    }
    
}


protocol SetCalendarViewControllerDelegate: class {
    func generateCalendarButtonTapped(startDateStr: String, endDateStr: String)
}

