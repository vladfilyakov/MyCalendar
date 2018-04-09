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
    // Outlook has a fixed agenda section header height
    private static let agendaSectionHeaderHeight: CGFloat = 26
    private static let separatorWidth = UIScreen.main.devicePixel
    
    private static let calendarViewNormalWeeks = 2
    private static let calendarViewExpandedWeeks = 5

    private static let selectedDateColor = UIColor(red: 0, green: 0.47, blue: 0.85, alpha: 1)
    private static let separatorColor = UIColor(red: 0.88, green: 0.88, blue: 0.89, alpha: 1)

    private static let agendaSectionHeaderFont = UIFont.preferredFont(forTextStyle: .subheadline)
    private static let agendaSectionHeaderBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
    private static let agendaSectionHeaderTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    private static let agendaSectionHeaderTodayBackgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.99, alpha: 1)
    private static let agendaSectionHeaderTodayTextColor = selectedDateColor

    private static let titleFont = UIFont.boldSystemFont(ofSize: 17)
    private static let titleTextColor = selectedDateColor

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
    private(set) lazy var agendaView: UITableView = {
        let agendaView = UITableView()
        agendaView.allowsSelection = false
        agendaView.estimatedRowHeight = 0
        agendaView.estimatedSectionHeaderHeight = 0
        agendaView.scrollsToTop = false
        agendaView.sectionHeaderHeight = CalendarController.agendaSectionHeaderHeight
        agendaView.separatorColor = CalendarController.separatorColor
        agendaView.separatorInset = .zero
        agendaView.showsVerticalScrollIndicator = false
        agendaView.dataSource = self
        agendaView.delegate = self
        agendaView.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.identifier)
        agendaView.register(EmptyAgendaCell.self, forCellReuseIdentifier: EmptyAgendaCell.identifier)
        agendaView.register(AgendaHeaderView.self, forHeaderFooterViewReuseIdentifier: AgendaHeaderView.identifier)
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
        }
    }
    private var isScrollingAgendaView: Bool = false

    func setSelectedDate(_ date: Date?, excludingAgenda: Bool = false, animated: Bool) {
        titleView.text = date != nil ? CalendarFormatter.fullMonthString(from: date!) : nil
        titleView.sizeToFit()
        
        calendarView.setSelectedDate(date, animated: animated)
        
        if !excludingAgenda, let date = date {
            agendaView.scrollToRow(at: IndexPath(row: 0, section: agendaSection(for: date)), at: .top, animated: animated)
            // Assignment of isScrollingAgendaView should be after scrollToRow
            // because it calls scrollViewDidEndScrollingAnimation for the currently running animation
            isScrollingAgendaView = animated
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
        frame.origin.y = frame.maxY - CalendarController.separatorWidth
        frame.size.height = CalendarController.separatorWidth
        
        let separator = UIView(frame: frame)
        separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        separator.backgroundColor = CalendarWeekCell.separatorColor
        separator.isUserInteractionEnabled = false
        return separator
    }
    
    @objc private func titleTapped() {
        isCalendarViewExpanded = !isCalendarViewExpanded
    }
}

// MARK: - CalendarController: CalendarViewDelegate - for Calendar view

extension CalendarController: CalendarViewDelegate {
    func calendarView(_ view: CalendarView, didSelectDate date: Date?) {
        setSelectedDate(date, animated: true)
    }
    
    func calendarViewWillBeginDragging(_ view: CalendarView) {
        isCalendarViewExpanded = true
    }
}

// MARK: - CalendarController: UITableViewDataSource, UITableViewDelegate - for Agenda View

extension CalendarController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingAgendaView = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScrollingAgendaView, let tableView = scrollView as? UITableView else {
            return
        }
        // Checkpoint is a bottom of the top section header
        var checkPoint = tableView.contentOffset
        checkPoint.y += tableView.sectionHeaderHeight
        if let topIndexPath = tableView.indexPathForRow(at: checkPoint) {
            setSelectedDate(date(forAgendaSection: topIndexPath.section), excludingAgenda: true, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isCalendarViewExpanded = false
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let tableView = scrollView as? UITableView, let targetIndexPath = tableView.indexPathForRow(at: targetContentOffset.pointee) else {
            return
        }
        let targetCellRect = tableView.rectForRow(at: targetIndexPath)
        // Checkpoint is a bottom of the top section header
        if targetContentOffset.pointee.y + tableView.sectionHeaderHeight < targetCellRect.midY {
            // Need to scroll to the top of the section header otherwise the row will be covered by it
            targetContentOffset.pointee.y = targetCellRect.minY - tableView.sectionHeaderHeight
        } else {
            targetContentOffset.pointee.y = targetCellRect.maxY
            // For the last row in section its bottom is a top of the next section header, otherwise the previous comment applies
            if targetIndexPath.row < tableView.numberOfRows(inSection: targetIndexPath.section) - 1 {
                targetContentOffset.pointee.y -= tableView.sectionHeaderHeight
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(calendarView.maxDate.daysSince(calendarView.minDate)) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDate = date(forAgendaSection: section)
        return max(1, CalendarEvents.shared.events[sectionDate]?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let event = eventForRow(at: indexPath) {
            return AgendaCell.height(for: event, maxWidth: tableView.bounds.width)
        } else {
            return EmptyAgendaCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CalendarFormatter.fullString(from: date(forAgendaSection: section))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: AgendaHeaderView.identifier) as! AgendaHeaderView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let event = eventForRow(at: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.identifier, for: indexPath) as! AgendaCell
            cell.initialize(event: event)
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: EmptyAgendaCell.identifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {
            return
        }
        let dateIsToday = date(forAgendaSection: section).isToday
        // font/backgroundColor have to be set here instead of AgendaHeaderView because otherwise they will be overwritten by UIKit
        headerView.textLabel?.font = CalendarController.agendaSectionHeaderFont
        headerView.textLabel?.textColor = dateIsToday ? CalendarController.agendaSectionHeaderTodayTextColor : CalendarController.agendaSectionHeaderTextColor
        headerView.backgroundView?.backgroundColor = dateIsToday ? CalendarController.agendaSectionHeaderTodayBackgroundColor : CalendarController.agendaSectionHeaderBackgroundColor
    }
    
    private func agendaSection(for date: Date) -> Int {
        return date.daysSince(calendarView.minDate)
    }
    
    private func date(forAgendaSection section: Int) -> Date {
        return calendarView.minDate.addingDays(section)
    }
    
    private func eventForRow(at indexPath: IndexPath) -> CalendarEvent? {
        let sectionDate = date(forAgendaSection: indexPath.section)
        if let events = CalendarEvents.shared.events[sectionDate], !events.isEmpty {
            return events[indexPath.row]
        } else {
            return nil
        }
    }
}
