//
//  CalendarView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

// CalendarView is pseudo-infinite calendar view (just like the one in Outlook) which is practical for our use case
// Alternative implementation of dayView could be done using UICollectionView, but so far simpler UITableView is enough

// TODO: Semi-transparent cover with month information during scrolling - is this really needed for our scenario? Do people scroll far from today?
// TODO: Highlight today when not selected

// MARK: - CalendarViewDelegate

@objc protocol CalendarViewDelegate: class {
    func calendarView(_ view: CalendarView, didSelectDate date: Date?)
    @objc optional func calendarViewWillBeginDragging(_ view: CalendarView)
}

// MARK: - CalendarView

class CalendarView: UIView {
    private static let numberOfWeeksAnimationDuration: TimeInterval = 0.2
    
    override init(frame: CGRect) {
        // Outlook goes back about 3000 days and forward about 653
        let today = Date()
        minDate = Calendar.current.startOfWeek(for: today.addingDays(-3000))
        let pastWeeks = Int(Calendar.current.startOfWeek(for: today).daysSince(minDate) / 7)
        let futureWeeks = pastWeeks
        totalWeeks = pastWeeks + 1 + futureWeeks
        maxDate = minDate.addingDays(totalWeeks * 7 - 1)
        super.init(frame: .zero)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private var _numberOfWeeks: Int = 5
    var numberOfWeeks: Int {
        get { return _numberOfWeeks }
        set { setNumberOfWeeks(newValue, animated: false) }
    }
    private var _selectedDate: Date?
    var selectedDate: Date? {
        get { return _selectedDate }
        set { setSelectedDate(newValue, animated: false) }
    }
    
    let minDate: Date
    let maxDate: Date
    private let totalWeeks: Int
    
    weak var delegate: CalendarViewDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIViewNoIntrinsicMetric,
            height: CalendarHeaderView.height + CGFloat(numberOfWeeks) * dayView.rowHeight
        )
    }
    
    private lazy var dayView: UITableView = {
        let dayView = UITableView(frame: .zero, style: .plain)
        dayView.allowsSelection = false
        dayView.rowHeight = CalendarWeekCell.height
        dayView.estimatedRowHeight = dayView.rowHeight
        dayView.scrollsToTop = false
        dayView.separatorColor = CalendarWeekCell.separatorColor
        dayView.separatorInset = .zero
        dayView.showsVerticalScrollIndicator = false
        dayView.dataSource = self
        dayView.delegate = self
        dayView.register(CalendarWeekCell.self, forCellReuseIdentifier: CalendarWeekCell.identifier)
        return dayView
    }()
    private let headerView: CalendarHeaderView = CalendarHeaderView()
    
    private var lastIndexPathForScrollingToRow: IndexPath?
    
    func makeDateVisible(_ date: Date, animated: Bool) {
        guard let indexPath = indexPath(for: date) else {
            return
        }
        if indexPath == lastIndexPathForScrollingToRow {
            return
        }
        lastIndexPathForScrollingToRow = animated ? indexPath : nil
        dayView.scrollToRow(at: indexPath, at: .none, animated: animated)
    }

    func setNumberOfWeeks(_ numberOfWeeks: Int, animated: Bool) {
        let newNumberOfWeeks = max(1, numberOfWeeks)
        if self.numberOfWeeks == newNumberOfWeeks {
            return
        }
        
        let oldNumberOfWeeks = self.numberOfWeeks
        _numberOfWeeks = newNumberOfWeeks
        invalidateIntrinsicContentSize()

        if animated {
            UIView.animate(withDuration: CalendarView.numberOfWeeksAnimationDuration) {
                self.superview?.layoutIfNeeded()
                if self.numberOfWeeks < oldNumberOfWeeks, let date = self.selectedDate {
                    self.makeDateVisible(date, animated: false)
                }
            }
        } else {
            if self.numberOfWeeks < oldNumberOfWeeks, let date = self.selectedDate {
                self.superview?.layoutIfNeeded()
                self.makeDateVisible(date, animated: false)
            }
        }
    }
    
    func setSelectedDate(_ date: Date?, animated: Bool) {
        var newSelectedDate = date
        if let date = newSelectedDate {
            newSelectedDate = Calendar.current.startOfDay(for: date)
        }
        if selectedDate == newSelectedDate {
            return
        }
        
        let oldSelectedDate = selectedDate
        _selectedDate = newSelectedDate
        updateCell(for: oldSelectedDate)
        updateCell(for: selectedDate)
        if let date = selectedDate {
            makeDateVisible(date, animated: animated)
        }
    }
    
    private func initLayout() {
        addSubview(dayView)
        // headerView should be after dayView because it needs to show a separator/shadow over dayView
        addSubview(headerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerView.frame = frameForHeaderView()
        dayView.frame = frameForDayView()
    }
    
    private func frameForHeaderView() -> CGRect {
        var frame = bounds
        frame.size.height = CalendarHeaderView.height
        return frame
    }
    
    private func frameForDayView() -> CGRect {
        var frame = bounds
        frame.origin.y += CalendarHeaderView.height
        frame.size.height -= CalendarHeaderView.height
        return frame
    }
}

// MARK: - CalendarView: UITableViewDataSource, UITableViewDelegate - for Day View

extension CalendarView: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let indexPath = lastIndexPathForScrollingToRow, dayView.indexPathsForVisibleRows?.contains(indexPath) == true {
            lastIndexPathForScrollingToRow = nil
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.calendarViewWillBeginDragging?(self)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee.y = round(targetContentOffset.pointee.y / dayView.rowHeight) * dayView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalWeeks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarWeekCell.identifier, for: indexPath) as! CalendarWeekCell
        cell.initialize(weekStartDate: minDate.addingDays(indexPath.row * 7), selectedDate: selectedDate)
        cell.delegate = self
        return cell
    }
    
    private func indexPath(for date: Date) -> IndexPath? {
        let startOfWeek = Calendar.current.startOfWeek(for: date)
        if startOfWeek < minDate || startOfWeek > maxDate {
            return nil
        }
        let week = Int(startOfWeek.daysSince(minDate) / 7)
        return IndexPath(row: week, section: 0)
    }
    
    private func updateCell(for date: Date?) {
        if let date = date, let indexPath = indexPath(for: date), let cell = dayView.cellForRow(at: indexPath) as? CalendarWeekCell {
            cell.initialize(weekStartDate: cell.weekStartDate, selectedDate: selectedDate)
        }
    }
}

// MARK: - CalendarView: CalendarWeekCellDelegate - for Day View cells

extension CalendarView: CalendarWeekCellDelegate {
    func calendarWeekCell(_ cell: CalendarWeekCell, wasTappedOnDate date: Date) {
        let oldSelectedDate = selectedDate
        selectedDate = date
        if selectedDate != oldSelectedDate {
            delegate?.calendarView(self, didSelectDate: selectedDate)
        }
    }
}
