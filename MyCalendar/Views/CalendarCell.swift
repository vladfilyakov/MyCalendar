//
//  CalendarCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {
    static let identifier = "CalendarCell"
    
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
    
    private var weekDayViews: [UILabel] = {
        var weekDayViews = [UILabel]()
        for day in 0..<7 {
            let label = UILabel()
            label.textAlignment = .center
            weekDayViews.append(label)
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
            let date = weekStartDate.addingDays(i)
            let day = Calendar.current.component(.day, from: date)
            weekDayViews[i].text = NumberFormatter.localizedString(from: NSNumber(value: day), number: .none)
        }
    }
}
