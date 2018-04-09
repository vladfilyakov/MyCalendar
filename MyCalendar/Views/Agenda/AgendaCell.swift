//
//  AgendaCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/30/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

// TODO: Highlight the current event (hapenning right now)
// TODO: Show time left before next upcoming event

class AgendaCell: UITableViewCell {
    static let identifier = "AgendaCell"
    
    private static let horizontalMargin: CGFloat = 16
    private static let verticalMargin: CGFloat = 15
    private static let infoContainerSpacing: CGFloat = 7
    private static let locationContainerSpacing: CGFloat = 3
    private static let locationIconSize: CGFloat = 16
    private static let separatorThickness = UIScreen.main.devicePixel
    private static let subjectNumberOfLines = 2
    private static let timeContainerSpacing: CGFloat = 4
    // TODO: Calculate wider width for Large Text
    private static let timeContainerWidth: CGFloat = 70
    
    private static let durationFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let locationFont = UIFont.preferredFont(forTextStyle: .footnote)
    private static let startFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let subjectFont = UIFont.preferredFont(forTextStyle: .subheadline)

    private static let durationTextColor = UIColor(red: 0.65, green: 0.66, blue: 0.67, alpha: 1)
    private static let locationTextColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
    private static let startTextColor = subjectTextColor
    private static let subjectTextColor = UIColor(white: 0.13, alpha: 1)
    
    static func height(for event: CalendarEvent, maxWidth: CGFloat) -> CGFloat {
        let timeContainerHeight = UIScreen.main.roundToDevicePixels(startFont.lineHeight) + timeContainerSpacing + UIScreen.main.roundToDevicePixels(durationFont.lineHeight)
        
        let maxContentWidth = max(0, maxWidth - 2 * horizontalMargin)
        let maxSubjectWidth = max(0, maxContentWidth - timeContainerWidth)
        let maxSubjectHeight = UIScreen.main.roundToDevicePixels(CGFloat(subjectNumberOfLines) * subjectFont.lineHeight + CGFloat(subjectNumberOfLines - 1) * subjectFont.leading)
        let rect = (event.subject as NSString).boundingRect(
            with: CGSize(width: maxSubjectWidth, height: maxSubjectHeight),
            options: [.usesLineFragmentOrigin],
            attributes: [.font : subjectFont],
            context: nil
        )
        var infoContainerHeight = UIScreen.main.roundToDevicePixels(rect.height)
        // Compensation for baseline alignment
        infoContainerHeight -= UIScreen.main.roundToDevicePixels(subjectFont.ascender - startFont.ascender)
        
        if !event.location.isEmpty {
            infoContainerHeight += infoContainerSpacing + max(locationIconSize, UIScreen.main.roundToDevicePixels(locationFont.lineHeight))
        }
        
        return 2 * verticalMargin + max(timeContainerHeight, infoContainerHeight) + separatorThickness
    }
    
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
        locationLabel.text = event.location
        locationContainer.isHidden = event.location.isEmpty
    }
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = AgendaCell.durationFont
        label.textColor = AgendaCell.durationTextColor
        return label
    }()
    private let locationIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "icon-pin"))
        icon.tintColor = AgendaCell.locationTextColor
        icon.widthAnchor.constraint(equalToConstant: AgendaCell.locationIconSize).isActive = true
        icon.heightAnchor.constraint(equalToConstant: AgendaCell.locationIconSize).isActive = true
        return icon
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = AgendaCell.locationFont
        label.textColor = AgendaCell.locationTextColor
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
        label.numberOfLines = AgendaCell.subjectNumberOfLines
        label.font = AgendaCell.subjectFont
        label.textColor = AgendaCell.subjectTextColor
        return label
    }()

    private lazy var container: UIStackView = {
        let container = UIStackView(arrangedSubviews: [timeContainer, infoContainer])
        container.axis = .horizontal
        container.alignment = .firstBaseline
        container.isLayoutMarginsRelativeArrangement = true
        container.layoutMargins = UIEdgeInsets(
            top: AgendaCell.verticalMargin,
            left: AgendaCell.horizontalMargin,
            bottom: AgendaCell.verticalMargin,
            right: AgendaCell.horizontalMargin
        )
        return container
    }()
    private lazy var infoContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [subjectLabel, locationContainer])
        container.axis = .vertical
        container.spacing = AgendaCell.infoContainerSpacing
        return container
    }()
    private lazy var locationContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = AgendaCell.locationContainerSpacing
        return container
    }()
    private lazy var timeContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [startLabel, durationLabel])
        container.axis = .vertical
        container.spacing = AgendaCell.timeContainerSpacing
        container.widthAnchor.constraint(equalToConstant: AgendaCell.timeContainerWidth).isActive = true
        return container
    }()

    private func initLayout() {
        contentView.addSubview(container)
        container.fitIntoSuperview()
    }
}