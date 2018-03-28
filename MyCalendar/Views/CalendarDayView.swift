//
//  CalendarDayView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/27/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {
    static let dayTextVerticalMargin: CGFloat = 14
    static var height: CGFloat {
        // TODO: Support Large Fonts
        return UIScreen.main.roundToDevicePixels(2 * dayTextVerticalMargin + dayTextFont.lineHeight)
    }
    
    static let dayTextFont = UIFont.systemFont(ofSize: 17)
    static let monthTextFont = UIFont.systemFont(ofSize: 13)
    static let yearTextFont = UIFont.systemFont(ofSize: 13)
    
    static let dayTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    static let monthBackgroundColor1 = UIColor.white
    static let monthBackgroundColor2 = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    var date: Date! {
        didSet {
            if date != oldValue {
                updateView()
            }
        }
    }
    
    private lazy var container: UIStackView = {
        let container = UIStackView(arrangedSubviews: [monthLabel, dayLabel, yearLabel])
        container.axis = .vertical
        container.distribution = .fillEqually
        return container
    }()
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = CalendarDayView.dayTextFont
        label.textAlignment = .center
        label.textColor = CalendarDayView.dayTextColor
        return label
    }()
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = CalendarDayView.monthTextFont
        label.textAlignment = .center
        label.textColor = CalendarDayView.dayTextColor
        return label
    }()
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = CalendarDayView.yearTextFont
        label.textAlignment = .center
        label.textColor = CalendarDayView.dayTextColor
        return label
    }()
    
    private func backgroundColorForMonth(_ month: Int) -> UIColor {
        return month % 2 == 1 ? CalendarDayView.monthBackgroundColor1 : CalendarDayView.monthBackgroundColor2
    }
    
    private func displayTextForDay(_ day: Int) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: day), number: .none)
    }
    
    private func displayTextForMonth(_ month: Int) -> String {
        return Calendar.current.shortMonthSymbols[month - 1]
    }
    
    private func displayTextForYear(_ year: Int) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: year), number: .none)
    }

    private func initLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        container.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        container.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
    }
    
    private func updateView() {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year else {
            fatalError("Unexpected")
        }
        
        monthLabel.isHidden = !(day == 1)
        if !monthLabel.isHidden {
            monthLabel.text = displayTextForMonth(month)
        }
        
        dayLabel.text = displayTextForDay(day)
        
        yearLabel.isHidden = !(day == 1 && year != Calendar.current.component(.year, from: Date()))
        if !yearLabel.isHidden {
            yearLabel.text = displayTextForYear(year)
        }
        
        backgroundColor = backgroundColorForMonth(month)
    }
}
