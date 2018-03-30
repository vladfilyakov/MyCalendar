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

class CalendarController: UIViewController {
    private static let titleColor = UIColor(red: 0, green: 0.47, blue: 0.85, alpha: 1)
    private static let titleFont = UIFont.boldSystemFont(ofSize: 17)
    
    private(set) lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = CalendarController.titleFont
        titleView.textColor = CalendarController.titleColor
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
        return agendaView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        
        // Hiding navigation bar's bottom shadow to get a "merged" with calendar header look
        navigationController?.navigationBar.shadowImage = UIImage()
        
        titleView.text = "March 2018"   //!!!
        navigationItem.titleView = titleView
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
