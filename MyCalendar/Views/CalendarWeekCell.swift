//
//  CalendarWeekCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

protocol CalendarWeekCellDelegate: class {
    func calendarWeekCell(_ cell: CalendarWeekCell, wasTappedOnDate date: Date)
}

class CalendarWeekCell: UITableViewCell {
    static let identifier = "CalendarWeekCell"
    
    static var height: CGFloat {
        // Outlook has a fixed cell height
        //return CalendarDayView.height + separatorThickness
        return 48
    }
    static let separatorThickness = UIScreen.main.devicePixel

    static let separatorColor = UIColor(red: 0.88, green: 0.88, blue: 0.89, alpha: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private(set) var weekStartDate: Date!
    
    weak var delegate: CalendarWeekCellDelegate?
    
    private lazy var dayViews: [CalendarDayView] = {
        var dayViews = [CalendarDayView]()
        for day in 0..<7 {
            let dayView = CalendarDayView()
            dayView.tapped = { [unowned self, unowned dayView] in
                self.dayViewTapped(dayView)
            }
            dayViews.append(dayView)
        }
        return dayViews
    }()
    
    func initialize(weekStartDate: Date, selectedDate: Date?) {
        self.weekStartDate = weekStartDate
        for i in 0..<dayViews.count {
            let dayView = dayViews[i]
            dayView.date = weekStartDate.addingDays(i)
            dayView.isSelected = dayView.date == selectedDate
        }
    }
    
    private func initLayout() {
        dayViews.forEach { contentView.addSubview($0) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.fitSubviewsHorizontally(dayViews)
    }
    
    private func dayViewTapped(_ dayView: CalendarDayView) {
        delegate?.calendarWeekCell(self, wasTappedOnDate: dayView.date)
    }
}
