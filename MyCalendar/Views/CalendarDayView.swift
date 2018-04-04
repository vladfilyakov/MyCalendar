//
//  CalendarDayView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/27/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {
//    private static let dayTextVerticalMargin: CGFloat = 14
//    static var height: CGFloat {
//        // TODO: Support Large Fonts
//        return UIScreen.main.roundToDevicePixels(2 * dayTextVerticalMargin + dayTextFont.lineHeight)
//    }
    private static let selectionIndicatorMargin: CGFloat = 5
    
    private static let dayTextFont = UIFont.systemFont(ofSize: 17)
    private static let monthTextFont = UIFont.systemFont(ofSize: 13)
    private static let yearTextFont = UIFont.systemFont(ofSize: 13)
    
    private static let backgroundColor1 = UIColor.white
    private static let backgroundColor2 = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
    private static let highlightBackgroundColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    private static let selectionBackgroundColor = UIColor(red: 0, green: 0.47, blue: 0.85, alpha: 1)
    private static let selectionTextColor = UIColor.white
    private static let textColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override var bounds: CGRect {
        didSet {
            if bounds != oldValue {
                updateSelectionIndicatorSize()
            }
        }
    }
    override var frame: CGRect {
        didSet {
            if frame != oldValue {
                updateSelectionIndicatorSize()
            }
        }
    }
    
    var date: Date! {
        didSet {
            if date != oldValue {
                updateView()
            }
        }
    }
    var isSelected: Bool = false {
        didSet {
            if isSelected != oldValue {
                updateView()
            }
        }
    }
    
    private var isHighlighted: Bool = false {
        didSet {
            if isHighlighted != oldValue {
                updateView()
            }
        }
    }
    
    // MARK: Layout
    
    private lazy var labelContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [monthLabel, dayLabel, yearLabel])
        container.axis = .vertical
        container.distribution = .fillEqually
        return container
    }()
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = CalendarDayView.dayTextFont
        label.textAlignment = .center
        label.textColor = CalendarDayView.textColor
        return label
    }()
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.font = CalendarDayView.monthTextFont
        label.textAlignment = .center
        label.textColor = CalendarDayView.textColor
        return label
    }()
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = CalendarDayView.yearTextFont
        label.textAlignment = .center
        label.textColor = CalendarDayView.textColor
        return label
    }()
    private var selectionIndicator: UIView? {
        didSet {
            if selectionIndicator == oldValue {
                return
            }
            
            oldValue?.removeFromSuperview()
            selectionIndicatorSizeConstraint = nil
            
            if let indicator = selectionIndicator {
                indicator.translatesAutoresizingMaskIntoConstraints = false
                insertSubview(indicator, at: 0)
                indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                selectionIndicatorSizeConstraint = indicator.widthAnchor.constraint(equalToConstant: 0)
                selectionIndicatorSizeConstraint?.isActive = true
                indicator.heightAnchor.constraint(equalTo: indicator.widthAnchor).isActive = true
                updateSelectionIndicatorSize()
            }
        }
    }
    private var selectionIndicatorSizeConstraint: NSLayoutConstraint?
    
    private func createSelectionIndicator() -> UIView {
        return UIView()
    }
    
    private func initLayout() {
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelContainer)
        labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        labelContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelContainer.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
    }
    
    private func updateSelectionIndicatorSize() {
        guard let indicator = selectionIndicator else {
            return
        }
        let size = max(0, min(bounds.width, bounds.height) - 2 * CalendarDayView.selectionIndicatorMargin)
        let radius = UIScreen.main.roundToDevicePixels(size / 2)
        indicator.layer.cornerRadius = radius
        selectionIndicatorSizeConstraint?.constant = 2 * radius
    }
    
    // MARK: Presentation
    
    private func backgroundColorForMonth(_ month: Int) -> UIColor {
        return month % 2 == 1 ? CalendarDayView.backgroundColor1 : CalendarDayView.backgroundColor2
    }
    
    private func displayTextForDay(_ day: Int) -> String {
        return CalendarFormatter.string(from: day)
    }
    
    private func displayTextForMonth(_ month: Int) -> String {
        return Calendar.current.shortMonthSymbols[month - 1]
    }
    
    private func displayTextForYear(_ year: Int) -> String {
        return CalendarFormatter.string(from: year)
    }

    private func updateView() {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year else {
            fatalError("Unexpected")
        }
        
        monthLabel.isHidden = !(day == 1) || isSelected
        if !monthLabel.isHidden {
            monthLabel.text = displayTextForMonth(month)
        }
        
        dayLabel.text = displayTextForDay(day)
        
        yearLabel.isHidden = !(day == 1 && year != Calendar.current.component(.year, from: Date())) || isSelected
        if !yearLabel.isHidden {
            yearLabel.text = displayTextForYear(year)
        }
        
        backgroundColor = backgroundColorForMonth(month)
        
        if isHighlighted || isSelected {
            if selectionIndicator == nil {
                selectionIndicator = createSelectionIndicator()
            }
            selectionIndicator?.backgroundColor = isHighlighted ? CalendarDayView.highlightBackgroundColor : CalendarDayView.selectionBackgroundColor
            dayLabel.textColor = CalendarDayView.selectionTextColor
        } else {
            selectionIndicator = nil
            dayLabel.textColor = CalendarDayView.textColor
        }
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //!!!
//        isSelected = true
        isSelected = !isSelected
        isHighlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
}
