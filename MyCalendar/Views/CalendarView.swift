//
//  CalendarView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .orange   //!!!
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    var numberOfWeeks: Int = 5 {
        didSet {
            numberOfWeeks = max(1, numberOfWeeks)
            if numberOfWeeks != oldValue {
                //!!!
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        //!!!
        return CGSize(width: UIViewNoIntrinsicMetric, height: CGFloat(numberOfWeeks) * 40)
    }
    
    private let minDate: Date = Calendar.current.startOfWeek(for: Date().addingDays(3000))
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        return container
    }()
    private lazy var dayView: UITableView = {
        let dayView = UITableView(frame: .zero, style: .plain)
        dayView.allowsSelection = false
        dayView.separatorInset = .zero
        dayView.dataSource = self
        dayView.delegate = self
        dayView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
        return dayView
    }()
    private lazy var headerView: CalendarHeaderView = {
        return CalendarHeaderView()
    }()
    
    func setNumberOfWeeks(_ numberOfWeeks: Int, animated: Bool) {
        self.numberOfWeeks = numberOfWeeks
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    private func initLayout() {
        container.frame = bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(container)
        
        container.addArrangedSubview(headerView)
        container.addArrangedSubview(dayView)
    }
}

extension CalendarView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Outlook Mobile goes back about 3000 days and forward about 653
        return (3000 + 3000) / 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        cell.weekStartDate = minDate.addingDays(indexPath.row * 7)
        return cell
    }
}