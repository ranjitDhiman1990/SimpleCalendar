//
//  InputAccessoryView.swift
//  CalendarDemo
//
//  Created by iOS Dev on 02/11/17.
//  Copyright © 2017 Personal Team. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var widthPreviousButton: NSLayoutConstraint!
    
    class func instanceFromNib() -> InputAccessoryView {
        return UINib(nibName: "InputAccessoryView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InputAccessoryView
    }

}
