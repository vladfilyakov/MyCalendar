//
//  AgendaView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 4/9/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

// MARK: AgendaViewDelegate

@objc protocol AgendaViewDelegate: class {
    @objc optional func agendaView(_ view: AgendaView, didScrollToDate date: Date)
    @objc optional func agendaViewWillBeginDragging(_ view: AgendaView)
}

// MARK: - AgendaView

class AgendaView: UIView {
    // Outlook has a fixed agenda section header height
    private static let sectionHeaderHeight: CGFloat = 26
    
    private static let selectedDateColor = UIColor(red: 0, green: 0.47, blue: 0.85, alpha: 1)
    private static let separatorColor = UIColor(red: 0.88, green: 0.88, blue: 0.89, alpha: 1)
    
    private static let sectionHeaderFont = UIFont.preferredFont(forTextStyle: .subheadline)
    private static let sectionHeaderBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
    private static let sectionHeaderTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    private static let sectionHeaderTodayBackgroundColor = UIColor(red: 0.95, green: 0.98, blue: 0.99, alpha: 1)
    private static let sectionHeaderTodayTextColor = selectedDateColor
    
    init(minDate: Date, maxDate: Date) {
        self.minDate = Calendar.current.startOfDay(for: minDate)
        self.maxDate = Calendar.current.startOfDay(for: maxDate)
        guard self.minDate <= self.maxDate else {
            fatalError("Unexpected")
        }
        super.init(frame: .zero)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    let minDate: Date
    let maxDate: Date
    
    weak var delegate: AgendaViewDelegate?
    
    private(set) lazy var eventView: UITableView = {
        let eventView = UITableView()
        eventView.allowsSelection = false
        eventView.estimatedRowHeight = 0
        eventView.estimatedSectionHeaderHeight = 0
        eventView.scrollsToTop = false
        eventView.sectionHeaderHeight = AgendaView.sectionHeaderHeight
        eventView.separatorColor = AgendaView.separatorColor
        eventView.separatorInset = .zero
        eventView.showsVerticalScrollIndicator = false
        eventView.dataSource = self
        eventView.delegate = self
        eventView.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.identifier)
        eventView.register(EmptyAgendaCell.self, forCellReuseIdentifier: EmptyAgendaCell.identifier)
        eventView.register(AgendaHeaderView.self, forHeaderFooterViewReuseIdentifier: AgendaHeaderView.identifier)
        return eventView
    }()

    private var isScrollingEventView: Bool = false
    
    func scrollToDate(_ date: Date, animated: Bool) {
        eventView.scrollToRow(at: IndexPath(row: 0, section: eventSection(for: date)), at: .top, animated: animated)
        // Assignment of isScrollingEventView should be after scrollToRow
        // because it calls scrollViewDidEndScrollingAnimation for the currently running animation
        isScrollingEventView = animated
    }
    
    private func initLayout() {
        addSubview(eventView)
        eventView.fitIntoSuperview()
    }
}

// MARK: - AgendaView: UITableViewDataSource, UITableViewDelegate - for Event view

extension AgendaView: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingEventView = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScrollingEventView, let tableView = scrollView as? UITableView else {
            return
        }
        // Checkpoint is a bottom of the top section header
        var checkPoint = tableView.contentOffset
        checkPoint.y += tableView.sectionHeaderHeight
        if let topIndexPath = tableView.indexPathForRow(at: checkPoint) {
            delegate?.agendaView?(self, didScrollToDate: date(forEventSection: topIndexPath.section))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.agendaViewWillBeginDragging?(self)
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
        return Int(maxDate.daysSince(minDate)) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDate = date(forEventSection: section)
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
        return CalendarFormatter.fullString(from: date(forEventSection: section))
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
        let dateIsToday = date(forEventSection: section).isToday
        // font/backgroundColor have to be set here instead of AgendaHeaderView because otherwise they will be overwritten by UIKit
        headerView.textLabel?.font = AgendaView.sectionHeaderFont
        headerView.textLabel?.textColor = dateIsToday ? AgendaView.sectionHeaderTodayTextColor : AgendaView.sectionHeaderTextColor
        headerView.backgroundView?.backgroundColor = dateIsToday ? AgendaView.sectionHeaderTodayBackgroundColor : AgendaView.sectionHeaderBackgroundColor
    }
    
    private func eventSection(for date: Date) -> Int {
        return date.daysSince(minDate)
    }
    
    private func date(forEventSection section: Int) -> Date {
        return minDate.addingDays(section)
    }
    
    private func eventForRow(at indexPath: IndexPath) -> CalendarEvent? {
        let sectionDate = date(forEventSection: indexPath.section)
        if let events = CalendarEvents.shared.events[sectionDate], !events.isEmpty {
            return events[indexPath.row]
        } else {
            return nil
        }
    }
}
