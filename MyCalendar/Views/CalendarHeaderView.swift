//
//  CalendarHeaderView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/23/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {
    static let dayLabelVerticalMargin: CGFloat = 6
    static let separatorThickness = UIScreen.main.devicePixel
    
    static let dayLabelFont = UIFont.systemFont(ofSize: 12)

    static let dayLabelBackgroundColor = UIColor.white
    static let dayLabelTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    static let separatorColor = UIColor(red: 0.82, green: 0.83, blue: 0.83, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CalendarHeaderView.dayLabelBackgroundColor
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        // TODO: Support Large Fonts
        return CGSize(
            width: UIViewNoIntrinsicMetric,
            height: 2 * CalendarHeaderView.dayLabelVerticalMargin +
                UIScreen.main.roundToDevicePixels(CalendarHeaderView.dayLabelFont.lineHeight) +
                CalendarHeaderView.separatorThickness
        )
    }
    
    private lazy var container: UIStackView = {
        let container = UIStackView(arrangedSubviews: [dayLabelContainer, separator])
        container.axis = .vertical
        return container
    }()
    private lazy var dayLabelContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: dayLabels)
        container.axis = .horizontal
        container.distribution = .fillEqually
        return container
    }()
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
        separator.heightAnchor.constraint(equalToConstant: CalendarHeaderView.separatorThickness).isActive = true
        separator.backgroundColor = CalendarHeaderView.separatorColor
        return separator
    }()
    
    private func initLayout() {
        addSubview(container)
        container.fitIntoSuperview()
    }
}
