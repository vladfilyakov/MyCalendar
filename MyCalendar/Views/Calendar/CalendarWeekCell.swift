//
//  CalendarWeekCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

protocol CalendarWeekCellDelegate: class {
    func calendarWeekCell(_ cell: CalendarWeekCell, eventCountForDate date: Date) -> Int
    
    func calendarWeekCell(_ cell: CalendarWeekCell, wasTappedOnDate date: Date)
}

class CalendarWeekCell: UITableViewCell {
    static let identifier = "CalendarWeekCell"
    
    static var height: CGFloat {
        // Outlook has a fixed cell height
        return 48
    }
    static let separatorThickness = UIScreen.main.devicePixel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private(set) var weekStartDate: Date!
    
    private weak var delegate: CalendarWeekCellDelegate!
    
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
    
    func initialize(weekStartDate: Date, selectedDate: Date?, showsEventIndicators: Bool, delegate: CalendarWeekCellDelegate) {
        self.weekStartDate = weekStartDate
        self.delegate = delegate
        for i in 0..<dayViews.count {
            let dayView = dayViews[i]
            dayView.date = weekStartDate.addingDays(i)
            dayView.eventCount = eventCount(for: dayView.date)
            dayView.isSelected = dayView.date == selectedDate
            dayView.showEventIndicator(showsEventIndicators, animated: false)
        }
    }
    
    func showEventIndicators(_ visible: Bool, animated: Bool) {
        dayViews.forEach { $0.showEventIndicator(visible, animated: animated) }
    }
    
    private func initLayout() {
        dayViews.forEach { contentView.addSubview($0) }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.fitSubviewsHorizontally(dayViews)
    }
    
    private func dayViewTapped(_ dayView: CalendarDayView) {
        delegate.calendarWeekCell(self, wasTappedOnDate: dayView.date)
    }
    
    private func eventCount(for date: Date) -> Int {
        return delegate.calendarWeekCell(self, eventCountForDate: date)
    }
}
