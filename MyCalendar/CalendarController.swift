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
    private(set) lazy var titleView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont.boldSystemFont(ofSize: 17)
        titleView.textColor = titleView.tintColor   //!!!
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(titleTapped)))
        return titleView
    }()
    private(set) lazy var calendarView: CalendarView = {
        let calendarView = CalendarView()
        calendarView.numberOfWeeks = 2
        return calendarView
    }()
    private(set) lazy var agendaView: UITableView = {
        let agendaView = UITableView()
        return agendaView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        
        titleView.text = "March 2018"   //!!!
        navigationItem.titleView = titleView
    }
    
    private func initLayout() {
        let container = UIStackView(frame: view.bounds)
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.axis = .vertical
        view.addSubview(container)
        
        container.addArrangedSubview(calendarView)
        container.addArrangedSubview(agendaView)
    }
    
    @objc private func titleTapped() {
        calendarView.setNumberOfWeeks(calendarView.numberOfWeeks == 2 ? 5 : 2, animated: true)
    }
}
