//
//  AgendaCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/30/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class AgendaCell: UITableViewCell {
    static let identifier = "AgendaCell"
    
    private static let extraVerticalMargin: CGFloat = 7
    private static let timeContainerSpacing: CGFloat = 4
    private static let timeContainerWidth: CGFloat = 70
    
    private static let durationFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let startFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let subjectFont = UIFont.preferredFont(forTextStyle: .subheadline)

    private static let durationTextColor = UIColor(red: 0.65, green: 0.66, blue: 0.67, alpha: 1)
    private static let startTextColor = subjectTextColor
    private static let subjectTextColor = UIColor(white: 0.13, alpha: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func initialize(event: CalendarEvent) {
        subjectLabel.text = event.subject
        startLabel.text = CalendarFormatter.timeString(from: event.start)
        durationLabel.text = CalendarFormatter.durationString(from: event.duration)
    }
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = AgendaCell.durationFont
        label.textColor = AgendaCell.durationTextColor
        return label
    }()
    private let startLabel: UILabel = {
        let label = UILabel()
        label.font = AgendaCell.startFont
        label.textColor = AgendaCell.startTextColor
        return label
    }()
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = AgendaCell.subjectFont
        label.textColor = AgendaCell.subjectTextColor
        return label
    }()

    private lazy var container: UIStackView = {
        let container = UIStackView(arrangedSubviews: [timeContainer, subjectLabel])
        container.axis = .horizontal
        container.alignment = .firstBaseline
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(top: AgendaCell.extraVerticalMargin, left: 0, bottom: AgendaCell.extraVerticalMargin, right: 0)
        return container
    }()
    private lazy var timeContainer: UIStackView = {
        let timeContainer = UIStackView(arrangedSubviews: [startLabel, durationLabel])
        timeContainer.axis = .vertical
        timeContainer.spacing = AgendaCell.timeContainerSpacing
        timeContainer.widthAnchor.constraint(equalToConstant: AgendaCell.timeContainerWidth).isActive = true
        return timeContainer
    }()

    private func initLayout() {
        contentView.addSubview(container)
        container.fitIntoSuperview(usingMargins: true)
    }
}
