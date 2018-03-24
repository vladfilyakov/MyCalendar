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
    
    static var height: CGFloat {
        // TODO: Support Large Fonts
        return UIScreen.main.roundToDevicePixels(14 + UIFont.systemFont(ofSize: 17).lineHeight + 14)
    }
    
    static let dayTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    static let monthBackgroundColor1 = UIColor.white
    static let monthBackgroundColor2 = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
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
    
    private var weekDayViews: [UILabel] = {
        var weekDayViews = [UILabel]()
        for day in 0..<7 {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            label.textAlignment = .center
            label.textColor = CalendarWeekCell.dayTextColor
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
            let dateComponents = Calendar.current.dateComponents([.day, .month], from: date)
            weekDayViews[i].text = displayTextForDay(dateComponents.day!)
            weekDayViews[i].backgroundColor = backgroundColor(for: dateComponents.month!)
        }
    }
    
    private func displayTextForDay(_ day: Int) -> String {
        return NumberFormatter.localizedString(from: NSNumber(value: day), number: .none)
    }
    
    private func backgroundColor(for month: Int) -> UIColor {
        return month % 2 == 1 ? CalendarWeekCell.monthBackgroundColor1 : CalendarWeekCell.monthBackgroundColor2
    }
}
