//
//  CalendarViewController.swift
//  Productivity App
//
//  Created by Hritik Bharucha on 2/19/21.
//

import UIKit
import Calendar_iOS

class CalendarViewController: UIViewController, CalendarViewDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.calendarDelegate = self
        
        self.calendarView.selectionColor = UIColor.blue
        self.calendarView.fontHeaderColor = UIColor.blue
        
    }
    
    func didChangeCalendarDate(_ date: Date!) {
        
    }
    
}
