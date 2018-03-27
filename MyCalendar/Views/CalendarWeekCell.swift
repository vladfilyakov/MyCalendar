//
//  CalendarWeekCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarWeekCell: UITableViewCell {
    static let identifier = "CalendarWeekCell"
    
    static var height: CGFloat { return CalendarDayView.height }
    
    static let separatorColor = UIColor(red: 0.88, green: 0.88, blue: 0.89, alpha: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    var weekStartDate: Date! {
        didSet {
            if weekStartDate != oldValue {
                updateViews()
            }
        }
    }
    
    private let weekDayViews: [CalendarDayView] = {
        var weekDayViews = [CalendarDayView]()
        for day in 0..<7 {
            weekDayViews.append(CalendarDayView())
        }
        return weekDayViews
    }()
    
    private func initLayout() {
        let container = UIStackView(arrangedSubviews: weekDayViews)
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.frame = contentView.bounds
        contentView.addSubview(container)
    }
    
    private func updateViews() {
        for i in 0..<7 {
            weekDayViews[i].date = weekStartDate.addingDays(i)
        }
    }
}
