//
//  CalendarHeaderView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {
    static var height: CGFloat {
        // Outlook has a fixed header height
        return 26
    }
    private static let separatorThickness = UIScreen.main.devicePixel
    
    private static let dayLabelFont = UIFont.preferredFont(forTextStyle: .caption1)

    private static let dayLabelBackgroundColor = Colors.background1
    private static let dayLabelTextColor = Colors.text2
    private static let separatorColor = Colors.transparentSeparator

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CalendarHeaderView.dayLabelBackgroundColor
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let dayLabels: [UILabel] = {
        var dayLabels = [UILabel]()
        for i in 0..<7 {
            let dayLabel = UILabel()
            dayLabel.text = Calendar.current.veryShortWeekdaySymbols[(Calendar.current.firstWeekday + i - 1) % 7]
            dayLabel.font = CalendarHeaderView.dayLabelFont
            dayLabel.textAlignment = .center
            dayLabel.textColor = CalendarHeaderView.dayLabelTextColor
            dayLabels.append(dayLabel)
        }
        return dayLabels
    }()
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = CalendarHeaderView.separatorColor
        return separator
    }()
    
    private func initLayout() {
        dayLabels.forEach { addSubview($0) }
        addSubview(separator)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fitSubviewsHorizontally(dayLabels)
        separator.frame = frameForSeparator()
    }
    
    private func frameForSeparator() -> CGRect {
        var frame = bounds
        frame.origin.y = frame.maxY
        frame.size.height = CalendarHeaderView.separatorThickness
        return frame
    }
}
