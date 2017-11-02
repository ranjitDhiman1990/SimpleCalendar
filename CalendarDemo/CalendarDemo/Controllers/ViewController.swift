//
//  ViewController.swift
//  CalendarDemo
//
//  Created by iOS Dev on 27/10/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SetCalendarViewControllerDelegate {

    @IBOutlet weak var calendarView: UICollectionView!
    
    
    var startDateStr = "2016-01-01"
    var endDateStr = "2020-02-01"
    
    let cellID = "cellID"
    let sectionHeaderID = "SectionHeader"
    var numberOfMonths: Int = 0
    var calendarMonthsDetails: [MonthDetails] = []
    var selectedDates: [Date] = []
    var todayDateIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupView()
    }

    
    func setupView() {
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.registerCells()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        if let layout = self.calendarView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
            self.calendarView.collectionViewLayout = layout
        }
        self.calendarView.showsVerticalScrollIndicator = false
        self.calendarView.showsHorizontalScrollIndicator = false
        
        self.generateCalendar()
        
    }
    
    
    func generateCalendar() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let todayWithoutTime = TimeUtility.getDateFromString(dateString: dateFormatter.string(from: date), dateFormat: dateFormat)
        
        self.calendarMonthsDetails = []
        self.todayDateIndexPath = nil
        self.numberOfMonths = 0
        
        if let startDate = TimeUtility.getDateFromString(dateString: self.startDateStr, dateFormat: dateFormat), let endDate = TimeUtility.getDateFromString(dateString: self.endDateStr, dateFormat: dateFormat) {
            self.numberOfMonths = endDate.months(from: startDate)
            var nextMonth = startDate
            for index in 0...numberOfMonths {
                let monthDetails = nextMonth.getMonthDetails()
                self.calendarMonthsDetails.append(monthDetails)
                
                // Get Today IndexPath for scrolling to the appropriate Month
                // Construct the date string like dateFormat string i.e. like "yyyy-MM-dd"
                let monthStartDateStr = "\(monthDetails.yearsString)-\(monthDetails.monthsString.mapMonthString())-01"
                let monthEndDateStr = "\(monthDetails.yearsString)-\(monthDetails.monthsString.mapMonthString())-\(monthDetails.numberOfDates)"
                if let startDate = TimeUtility.getDateFromString(dateString: monthStartDateStr, dateFormat: dateFormat), let endDate = TimeUtility.getDateFromString(dateString: monthEndDateStr, dateFormat: dateFormat), let today = todayWithoutTime, self.todayDateIndexPath == nil {
                    if today.isBetween(startDate, and: endDate) {
                        self.todayDateIndexPath = IndexPath(row: monthDetails.numberOfDates/2, section: index)
                    }
                }
                
                if let nxtMonth = nextMonth.getNextMonth() {
                    nextMonth = nxtMonth
                }
            }
        }
        
        self.calendarView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.scrollsToToday()
    }
    
    @IBAction func todayButtonClicked(_ sender: UIBarButtonItem) {
        self.scrollsToToday()
    }
    
    @IBAction func calendarButtonAction(_ sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "SetCalendarViewController") as? SetCalendarViewController {
            vc.delegate = self
            vc.startDateString = self.startDateStr
            vc.endDateString = self.endDateStr
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func scrollsToToday() {
        DispatchQueue.main.async {
            if let indexPath = self.todayDateIndexPath {
                self.calendarView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerCells() {
        self.calendarView.register(DateCell.loadNib(), forCellWithReuseIdentifier: self.cellID)
    }
    
    func generateCalendarButtonTapped(startDateStr: String, endDateStr: String) {
        self.startDateStr = startDateStr
        self.endDateStr = endDateStr
        self.generateCalendar()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfMonths
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForDates(indexPath: indexPath)
    }
    
    
    func cellForDates(indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.calendarView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as? DateCell {
            let offSetPosition = self.getLastMonthEndDateIndexOffset(section: indexPath.section)
            
            if indexPath.row >= offSetPosition &&  indexPath.row < (self.numberOfDates(section: indexPath.section) + offSetPosition) {
                cell.dateButton.setTitle("\((indexPath.row + 1) - offSetPosition)", for: UIControlState())
                cell.dateButton.setTitleColor(UIColor.black, for: UIControlState())
                cell.dateButton.backgroundColor = UIColor.clear
                
                let currentDateStr = "\(self.calendarMonthsDetails[indexPath.section].yearsString)-\(self.calendarMonthsDetails[indexPath.section].monthsString.mapMonthString())-\((indexPath.row + 1) - offSetPosition)"
                print("Current Date String = \(currentDateStr)")

                if let currentDate = TimeUtility.getDateFromString(dateString: currentDateStr, dateFormat: dateFormat) {
                    if self.checkIfDateIsSelectedOrNot(dateToComare: currentDate) {
                        cell.dateButton.setTitleColor(UIColor.white, for: UIControlState())
                        cell.dateButton.backgroundColor = UIColor.darkGray
                    }
                    
                    if currentDate.isToday() {
                        cell.dateButton.setTitleColor(UIColor.white, for: UIControlState())
                        cell.dateButton.backgroundColor = UIColor.blue
                    }
                    
                    if indexPath.row % 7 == 0 {
                        cell.dateButton.setTitleColor(UIColor.red, for: UIControlState())
                    }
                }
                
                // Date button tapping action
                cell.dateButtonTapped = {(cell) in
                    let offSetPosition = self.getLastMonthEndDateIndexOffset(section: indexPath.section)
                    
                    // Construct the date string like dateFormat string i.e. like "yyyy-MM-dd"
                    let currentDateStr = "\(self.calendarMonthsDetails[indexPath.section].yearsString)-\(self.calendarMonthsDetails[indexPath.section].monthsString.mapMonthString())-\((indexPath.row + 1) - offSetPosition)"
                    print("Current Date String = \(currentDateStr)")
                    
                    if let currentDate = TimeUtility.getDateFromString(dateString: currentDateStr, dateFormat: dateFormat) {
                        if !self.selectedDates.contains(currentDate) {
                            self.selectedDates.append(currentDate)
                        } else {
                            if let index = self.selectedDates.index(of: currentDate) {
                                self.selectedDates.remove(at: index)
                            }
                        }
                        
                        UIView.performWithoutAnimation {
                            let indexSet = IndexSet(integer: indexPath.section)
                            self.calendarView.reloadSections(indexSet)
                        }
                    }
                }
            } else {
                cell.backgroundColor = UIColor.clear
                cell.dateButton.setTitleColor(UIColor.clear, for: UIControlState())
                cell.dateButton.backgroundColor = UIColor.clear
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func checkIfDateIsSelectedOrNot(dateToComare: Date) -> Bool {
        var isSelected = false
        for currentDate in self.selectedDates {
            let order = NSCalendar.current.compare(dateToComare, to: currentDate, toGranularity: .hour)
            switch order {
            case .orderedDescending:
                print("DESCENDING")
            case .orderedAscending:
                print("ASCENDING")
            case .orderedSame:
                print("SAME")
                isSelected = true
                break
            }
        }
        
        return isSelected
    }
    
    func numberOfDates(section: Int) -> Int {
        return self.calendarMonthsDetails[section].numberOfDates
    }
    
    func getLastMonthEndDateIndexOffset(section: Int) -> Int {
        return self.calendarMonthsDetails[section].monthsStartDay
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offSetPosition = self.getLastMonthEndDateIndexOffset(section: indexPath.section)
        if indexPath.row < (self.numberOfDates(section: indexPath.section) + offSetPosition) {
            return CGSize(width: self.calendarView.frame.size.width/7, height: self.calendarView.frame.size.width/7)
        }
        
        return CGSize(width: 0.0, height: 0.0)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            return self.monthsHeaderView(kind: kind, indexPath: indexPath)
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func monthsHeaderView(kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = self.calendarView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionHeaderID, for: indexPath) as! SectionHeaderCollectionReusableView
        headerView.labelMonth?.text = self.calendarMonthsDetails[indexPath.section].monthsString
        headerView.labelYear?.text = self.calendarMonthsDetails[indexPath.section].yearsString
        
        
        let monthStartDateStr = "\(self.calendarMonthsDetails[indexPath.section].yearsString)-\(self.calendarMonthsDetails[indexPath.section].monthsString.mapMonthString())-01"
        print("Current Date String = \(monthStartDateStr)")
        let monthEndDateStr = "\(self.calendarMonthsDetails[indexPath.section].yearsString)-\(self.calendarMonthsDetails[indexPath.section].monthsString.mapMonthString())-\(self.calendarMonthsDetails[indexPath.section].numberOfDates)"
        print("Current Date String = \(monthEndDateStr)")

        headerView.labelSelectedDatesCount.text = ""
        if let monthStartDate = TimeUtility.getDateFromString(dateString: monthStartDateStr, dateFormat: dateFormat), let monthEndDate = TimeUtility.getDateFromString(dateString: monthEndDateStr, dateFormat: dateFormat) {
            let selectedDatesCount = self.getNumberOfSelectedDatesInThisMonth(monthStartDate: monthStartDate, monthEndDate: monthEndDate)
            if selectedDatesCount > 0 {
                headerView.labelSelectedDatesCount.text = selectedDatesCount > 1 ? "\(selectedDatesCount) dates" : "\(selectedDatesCount) date"
                headerView.labelSelectedDatesCount.textColor = UIColor.blue
            }
        } else {
            headerView.labelSelectedDatesCount.text = ""
        }
        
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
    
    func getNumberOfSelectedDatesInThisMonth(monthStartDate: Date, monthEndDate: Date) -> Int {
        var selectedDatesCounts = 0
        for currentDate in self.selectedDates {
            if currentDate.isBetween(monthStartDate, and: monthEndDate) {
                selectedDatesCounts += 1
            }
        }
        return selectedDatesCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.calendarView.frame.size.width, height: 66.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 44, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class DateCell: UICollectionViewCell {
    @IBOutlet weak var dateButton: UIButton!
    var dateButtonTapped: ((DateCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func dateButtonAction(_ sender: UIButton) {
        self.dateButtonTapped?(self)
    }
    
    class func loadNib() -> UINib {
        return UINib(nibName: "DateCell", bundle: nil)
    }
}

