//
//  CalendarController.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

// TODO: localization
// TODO: accessibility

// MARK: CalendarController

class CalendarController: UIViewController {
    // Outlook has a fixed agenda section header height
    private static let agendaSectionHeaderHeight: CGFloat = 26
    
    private static let agendaSectionHeaderFont = UIFont.preferredFont(forTextStyle: .subheadline)
    private static let agendaSectionHeaderTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    private static let titleFont = UIFont.boldSystemFont(ofSize: 17)
    private static let titleTextColor = UIColor(red: 0, green: 0.47, blue: 0.85, alpha: 1)

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
        calendarView.numberOfWeeks = 2
        calendarView.addSubview(createBottomSeparator(for: calendarView))
        return calendarView
    }()
    private(set) lazy var agendaView: UITableView = {
        let agendaView = UITableView()
        agendaView.sectionHeaderHeight = CalendarController.agendaSectionHeaderHeight
        agendaView.dataSource = self
        agendaView.delegate = self
        agendaView.register(AgendaCell.self, forCellReuseIdentifier: AgendaCell.identifier)
        return agendaView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        
        // Hiding navigation bar's bottom shadow to get a "merged" with calendar header look
        navigationController?.navigationBar.shadowImage = UIImage()
        
        titleView.text = "March 2018"   //!!!
        navigationItem.titleView = titleView
        
        //!!!
        calendarView.selectedDate = Date()
    }
    
    private func initLayout() {
        let container = UIStackView(arrangedSubviews: [calendarView, agendaView])
        container.axis = .vertical
        view.addSubview(container)
        container.fitIntoSuperview()
    }
    
    private func createBottomSeparator(for view: UIView) -> UIView {
        var frame = view.bounds
        frame.origin.y = frame.maxY - UIScreen.main.devicePixel
        frame.size.height = UIScreen.main.devicePixel
        
        let separator = UIView(frame: frame)
        separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        separator.backgroundColor = CalendarWeekCell.separatorColor
        separator.isUserInteractionEnabled = false
        return separator
    }
    
    @objc private func titleTapped() {
        calendarView.setNumberOfWeeks(calendarView.numberOfWeeks == 2 ? 5 : 2, animated: true)
    }
}

// MARK: - CalendarController: UITableViewDataSource, UITableViewDelegate - for Agenda View

extension CalendarController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let topIndexPath = (scrollView as? UITableView)?.indexPathsForVisibleRows?.first {
            calendarView.selectedDate = date(forAgendaSection: topIndexPath.section)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO: scroll to the whole cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(calendarView.maxDate.daysSince(calendarView.minDate)) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //!!!
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CalendarFormatter.fullString(from: date(forAgendaSection: section))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //!!!
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaCell.identifier, for: indexPath) as! AgendaCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {
            return
        }
        headerView.textLabel?.textColor = CalendarController.agendaSectionHeaderTextColor
        headerView.textLabel?.font = CalendarController.agendaSectionHeaderFont
    }
    
    private func date(forAgendaSection section: Int) -> Date {
        return calendarView.minDate.addingDays(section)
    }
}
