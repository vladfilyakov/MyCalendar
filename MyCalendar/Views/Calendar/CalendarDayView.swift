//
//  CalendarDayView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/27/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {
    private static let showEventIndicatorAnimationDuration: TimeInterval = 0.2
    
    private static let eventIndicatorBottomMargin: CGFloat = 7
    private static let eventIndicatorRadius: CGFloat = 2
    private static let selectionIndicatorMargin: CGFloat = 5
    
    private static let dayTextFont = UIFont.systemFont(ofSize: 17)
    private static let monthTextFont = UIFont.systemFont(ofSize: 13)
    private static let yearTextFont = UIFont.systemFont(ofSize: 13)

    private static let oddMonthBackgroundColor = Colors.backgroundColor2
    private static let evenMonthBackgroundColor = Colors.backgroundColor1
    private static let eventIndicatorColor = Colors.textColor2
    private static let eventIndicatorColorLevels = 4
    private static let highlightBackgroundColor = Colors.textColor2
    private static let selectionBackgroundColor = Colors.selectionColor1
    private static let selectionTextColor = Colors.textColor4
    private static let textColor = Colors.textColor2
    private static let todayBackgroundColor = Colors.selectionColor2
    private static let todayTextColor = Colors.selectionColor1
    
    private static func eventIndicatorColor(for eventCount: Int) -> UIColor {
        let alpha = CGFloat(min(eventCount, eventIndicatorColorLevels)) / CGFloat(eventIndicatorColorLevels)
        return eventIndicatorColor.withAlphaComponent(alpha)
    }
    
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
    var eventCount: Int = 0 {
        didSet {
            if eventCount != oldValue {
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
    
    var tapped: (() -> Void)?
    
    func showEventIndicator(_ visible: Bool, animated: Bool) {
        let action = {
            self.eventIndicator.alpha = visible ? 1 : 0
        }
        if animated {
            UIView.animate(withDuration: CalendarDayView.showEventIndicatorAnimationDuration, animations: action)
        } else {
            action()
        }
    }
    
    // MARK: Layout
    
    private lazy var labelContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [monthLabel, dayLabel, yearLabel])
        container.axis = .vertical
        container.distribution = .fillEqually
        container.isUserInteractionEnabled = false
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
    private let eventIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CalendarDayView.eventIndicatorRadius
        view.isUserInteractionEnabled = false
        view.widthAnchor.constraint(equalToConstant: 2 * CalendarDayView.eventIndicatorRadius).isActive = true
        view.heightAnchor.constraint(equalToConstant: 2 * CalendarDayView.eventIndicatorRadius).isActive = true
        return view
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
        let selectionIndicator = UIView()
        selectionIndicator.isUserInteractionEnabled = false
        return selectionIndicator
    }
    
    private func initLayout() {
        labelContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelContainer)
        labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        labelContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelContainer.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        
        eventIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(eventIndicator)
        eventIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        eventIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CalendarDayView.eventIndicatorBottomMargin).isActive = true
        showEventIndicator(false, animated: false)
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
    
    private func updateView() {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        guard let day = dateComponents.day, let month = dateComponents.month, let year = dateComponents.year else {
            fatalError("Unexpected")
        }
        
        let showsMonth = day == 1 && !(isHighlighted || isSelected)
        let showsYear = day == 1 && year != Calendar.current.component(.year, from: Date()) && !(isHighlighted || isSelected)
        let showsEventIndicator = !showsMonth && !showsYear && !(isHighlighted || isSelected)
        let presentationParams = self.presentationParams(month: month, isToday: date.isToday)

        monthLabel.isHidden = !showsMonth
        if showsMonth {
            monthLabel.text = CalendarFormatter.shortMonthString(from: date)
        }
        
        dayLabel.text = CalendarFormatter.string(from: day)
        
        yearLabel.isHidden = !showsYear
        if showsYear {
            yearLabel.text = CalendarFormatter.string(from: year)
        }
        
        eventIndicator.isHidden = !showsEventIndicator
        if showsEventIndicator {
            eventIndicator.backgroundColor = presentationParams.eventIndicatorColor
        }

        backgroundColor = presentationParams.backgroundColor
        dayLabel.textColor = presentationParams.textColor
        if let selectionColor = presentationParams.selectionColor {
            if selectionIndicator == nil {
                selectionIndicator = createSelectionIndicator()
            }
            selectionIndicator?.backgroundColor = selectionColor
        } else {
            selectionIndicator = nil
        }
    }
    
    private func presentationParams(month: Int, isToday: Bool) -> (backgroundColor: UIColor, textColor: UIColor, selectionColor: UIColor?, eventIndicatorColor: UIColor) {
        var params: (backgroundColor: UIColor, textColor: UIColor, selectionColor: UIColor?, eventIndicatorColor: UIColor)
        
        params.backgroundColor = month % 2 == 1 ? CalendarDayView.oddMonthBackgroundColor : CalendarDayView.evenMonthBackgroundColor
        params.textColor = CalendarDayView.textColor
        params.selectionColor = nil
        params.eventIndicatorColor = CalendarDayView.eventIndicatorColor(for: eventCount)

        if isHighlighted || isSelected {
            params.textColor = CalendarDayView.selectionTextColor
            params.selectionColor = isHighlighted ? CalendarDayView.highlightBackgroundColor : CalendarDayView.selectionBackgroundColor
        } else
            if isToday {
                params.backgroundColor = CalendarDayView.todayBackgroundColor
                params.textColor = CalendarDayView.todayTextColor
            }
        
        return params
    }
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        tapped?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
    }
}
