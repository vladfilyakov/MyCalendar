//
//  CalendarView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

// TODO: Semi-transparent cover with month information - is this really needed for our scenario? Do people scroll far from today?
// TODO: Highlight today when not selected

class CalendarView: UIView {
    override init(frame: CGRect) {
        // Outlook goes back about 3000 days and forward about 653
        let today = Date()
        minDate = Calendar.current.startOfWeek(for: today.addingDays(-3000))
        pastWeeks = Int(Calendar.current.startOfWeek(for: today).daysSince(minDate) / 7)
        futureWeeks = pastWeeks
        super.init(frame: .zero)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    var numberOfWeeks: Int = 5 {
        didSet {
            numberOfWeeks = max(1, numberOfWeeks)
            if numberOfWeeks != oldValue {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIViewNoIntrinsicMetric,
            height: CalendarHeaderView.height + CGFloat(numberOfWeeks) * dayView.rowHeight
        )
    }
    
    let minDate: Date
    private let pastWeeks: Int
    private let futureWeeks: Int
    
    private lazy var dayView: UITableView = {
        let dayView = UITableView(frame: .zero, style: .plain)
        dayView.allowsSelection = false
        dayView.rowHeight = CalendarWeekCell.height
        dayView.separatorColor = CalendarWeekCell.separatorColor
        dayView.separatorInset = .zero
        dayView.dataSource = self
        dayView.delegate = self
        dayView.register(CalendarWeekCell.self, forCellReuseIdentifier: CalendarWeekCell.identifier)
        return dayView
    }()
    private let headerView: CalendarHeaderView = CalendarHeaderView()
    
    func setNumberOfWeeks(_ numberOfWeeks: Int, animated: Bool) {
        self.numberOfWeeks = numberOfWeeks
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    private func initLayout() {
        addSubview(dayView)
        // headerView should after after dayView because it needs to show a separator/shadow over dayView
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

extension CalendarView: UITableViewDataSource, UITableViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee.y = round(targetContentOffset.pointee.y / dayView.rowHeight) * dayView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastWeeks + 1 + futureWeeks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarWeekCell.identifier, for: indexPath) as! CalendarWeekCell
        cell.weekStartDate = minDate.addingDays(indexPath.row * 7)
        return cell
    }
}
