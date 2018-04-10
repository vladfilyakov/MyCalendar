//
//  CalendarController.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

// TODO: accessibility

// MARK: CalendarController

class CalendarController: UIViewController {
    private static let calendarViewNormalWeeks = 2
    private static let calendarViewExpandedWeeks = 5

    private static let titleFont = UIFont.boldSystemFont(ofSize: 17)
    private static let titleTextColor = Colors.selectionColor1

    private(set) lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = CalendarController.titleFont
        titleView.textColor = CalendarController.titleTextColor
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleTapped)))
        return titleView
    }()
    private(set) lazy var calendarView: CalendarView = {
        let calendarView = CalendarView()
        calendarView.numberOfWeeks = CalendarController.calendarViewNormalWeeks
        calendarView.addSubview(createBottomSeparator(for: calendarView))
        calendarView.delegate = self
        return calendarView
    }()
    private(set) lazy var agendaView: AgendaView = {
        let agendaView = AgendaView(minDate: calendarView.minDate, maxDate: calendarView.maxDate)
        agendaView.delegate = self
        return agendaView
    }()
    
    private var isCalendarViewExpanded: Bool = false {
        didSet {
            if isCalendarViewExpanded == oldValue {
                return
            }
            calendarView.setNumberOfWeeks(
                isCalendarViewExpanded ? CalendarController.calendarViewExpandedWeeks : CalendarController.calendarViewNormalWeeks,
                animated: true
            )
            calendarView.setShowsEventIndicators(isCalendarViewExpanded, animated: true)
        }
    }

    func setSelectedDate(_ date: Date?, excludingAgenda: Bool = false, animated: Bool) {
        titleView.text = date != nil ? CalendarFormatter.fullMonthString(from: date!) : nil
        titleView.sizeToFit()
        
        calendarView.setSelectedDate(date, animated: animated)
        
        if !excludingAgenda, let date = date {
            agendaView.scrollToDate(date, animated: animated)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        
        // Hiding navigation bar's bottom shadow to get a "merged" with calendar header look
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.titleView = titleView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setSelectedDate(Date(), animated: false)
    }
    
    private func initLayout() {
        let container = UIStackView(arrangedSubviews: [calendarView, agendaView])
        container.axis = .vertical
        view.addSubview(container)
        container.fitIntoSuperview()
    }
    
    private func createBottomSeparator(for view: UIView) -> UIView {
        var frame = view.bounds
        frame.origin.y = frame.maxY - CalendarWeekCell.separatorThickness
        frame.size.height = CalendarWeekCell.separatorThickness
        
        let separator = UIView(frame: frame)
        separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        separator.backgroundColor = Colors.separatorColor
        separator.isUserInteractionEnabled = false
        return separator
    }
    
    @objc private func titleTapped() {
        isCalendarViewExpanded = !isCalendarViewExpanded
    }
}

// MARK: - CalendarController: AgendaViewDelegate

extension CalendarController: AgendaViewDelegate {
    func agendaView(_ view: AgendaView, eventsForDate date: Date) -> [CalendarEvent]? {
        return CalendarEvents.shared.events[date]
    }
    
    func agendaView(_ view: AgendaView, didScrollToDate date: Date) {
        setSelectedDate(date, excludingAgenda: true, animated: true)
    }
    
    func agendaViewWillBeginDragging(_ view: AgendaView) {
        isCalendarViewExpanded = false
    }
}

// MARK: - CalendarController: CalendarViewDelegate

extension CalendarController: CalendarViewDelegate {
    func calendarView(_ view: CalendarView, eventCountForDate date: Date) -> Int {
        return CalendarEvents.shared.events[date]?.count ?? 0
    }
    
    func calendarView(_ view: CalendarView, didSelectDate date: Date?) {
        setSelectedDate(date, animated: true)
    }
    
    func calendarViewWillBeginDragging(_ view: CalendarView) {
        isCalendarViewExpanded = true
    }
}
