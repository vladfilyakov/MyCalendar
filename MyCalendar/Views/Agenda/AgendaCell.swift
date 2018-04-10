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
    
    private static let horizontalMargin = AgendaView.contentHorizontalMargin
    private static let verticalMargin: CGFloat = 15
    private static let infoAreaSpacing: CGFloat = 7
    private static let locationAreaSpacing: CGFloat = 3
    private static let locationIconSize: CGFloat = 16
    private static let separatorThickness = UIScreen.main.devicePixel
    private static let timeAreaSpacing: CGFloat = 4
    private static let timeAreaWidth: CGFloat = max(70, 5 * startFont.pointSize)

    private static let durationFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let locationFont = UIFont.preferredFont(forTextStyle: .footnote)
    private static let startFont = UIFont.preferredFont(forTextStyle: .caption1)
    private static let subjectFont = UIFont.preferredFont(forTextStyle: .subheadline)

    private static let durationHeight = UIScreen.main.roundToDevicePixels(durationFont.lineHeight)
    private static let locationHeight = UIScreen.main.roundToDevicePixels(locationFont.lineHeight)
    private static let startHeight = UIScreen.main.roundToDevicePixels(startFont.lineHeight)
    private static let subjectLineHeight = UIScreen.main.roundToDevicePixels(subjectFont.lineHeight)
    private static let subjectMaxHeight = UIScreen.main.roundToDevicePixels(CGFloat(subjectNumberOfLines) * subjectFont.lineHeight + CGFloat(subjectNumberOfLines - 1) * subjectFont.leading)
    private static let subjectNumberOfLines = 2
    // Baseline alignment of subject label with start label
    private static let subjectVerticalOffset = UIScreen.main.roundToDevicePixels(startFont.ascender - subjectFont.ascender)

    private static let durationTextColor = Colors.text3
    private static let locationTextColor = Colors.text2
    private static let startTextColor = Colors.text1
    private static let subjectTextColor = Colors.text1
    
    static func height(for event: CalendarEvent, maxWidth: CGFloat) -> CGFloat {
        let timeAreaHeight = startHeight + timeAreaSpacing + durationHeight
        
        let contentMaxWidth = max(0, maxWidth - 2 * horizontalMargin)
        let subjectMaxWidth = max(0, contentMaxWidth - timeAreaWidth)
        let rect = (event.subject as NSString).boundingRect(
            with: CGSize(width: subjectMaxWidth, height: subjectMaxHeight),
            options: [.usesLineFragmentOrigin],
            attributes: [.font : subjectFont],
            context: nil
        )
        var infoAreaHeight = UIScreen.main.roundToDevicePixels(rect.height)
        // Compensation for baseline alignment
        infoAreaHeight += subjectVerticalOffset
        if !event.location.isEmpty {
            infoAreaHeight += infoAreaSpacing + max(locationIconSize, locationHeight)
        }
        
        return 2 * verticalMargin + max(timeAreaHeight, infoAreaHeight) + separatorThickness
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
    #if USE_CONSTRAINTS
        locationContainer.isHidden = event.location.isEmpty
    #else
        locationLabel.isHidden = event.location.isEmpty
        locationIcon.isHidden = locationLabel.isHidden
    #endif
    }
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = AgendaCell.durationFont
        label.textColor = AgendaCell.durationTextColor
        return label
    }()
    private let locationIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "icon-pin"))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = AgendaCell.locationTextColor
    #if USE_CONSTRAINTS
        icon.widthAnchor.constraint(equalToConstant: AgendaCell.locationIconSize).isActive = true
        icon.heightAnchor.constraint(equalToConstant: AgendaCell.locationIconSize).isActive = true
    #endif
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

#if USE_CONSTRAINTS
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
        container.spacing = AgendaCell.infoAreaSpacing
        return container
    }()
    private lazy var locationContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = AgendaCell.locationAreaSpacing
        return container
    }()
    private lazy var timeContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [startLabel, durationLabel])
        container.axis = .vertical
        container.spacing = AgendaCell.timeAreaSpacing
        container.widthAnchor.constraint(equalToConstant: AgendaCell.timeAreaWidth).isActive = true
        return container
    }()
#else
    private var contentBounds: CGRect {
        return contentView.bounds.insetBy(dx: AgendaCell.horizontalMargin, dy: AgendaCell.verticalMargin)
    }
    private var infoAreaBounds: CGRect {
        var bounds = contentBounds
        bounds.origin.x += AgendaCell.timeAreaWidth
        bounds.size.width -= AgendaCell.timeAreaWidth
        return bounds
    }
    private var locationAreaBounds: CGRect {
        var bounds = infoAreaBounds
        let height = max(AgendaCell.locationIconSize, AgendaCell.locationHeight)
        bounds.origin.y = bounds.maxY - height
        bounds.size.height = height
        return bounds
    }
    private var timeAreaBounds: CGRect {
        var bounds = contentBounds
        bounds.size.width = AgendaCell.timeAreaWidth
        return bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        startLabel.frame = frameForStartLabel()
        durationLabel.frame = frameForDurationLabel()
        subjectLabel.frame = frameForSubjectLabel()
        locationIcon.frame = frameForLocationIcon()
        locationLabel.frame = frameForLocationLabel()
    }
    
    private func frameForStartLabel() -> CGRect {
        var frame = timeAreaBounds
        frame.size.height = AgendaCell.startHeight
        return frame
    }
    
    private func frameForDurationLabel() -> CGRect {
        var frame = timeAreaBounds
        frame.origin.y = frameForStartLabel().maxY + AgendaCell.timeAreaSpacing
        frame.size.height = AgendaCell.durationHeight
        return frame
    }
    
    private func frameForSubjectLabel() -> CGRect {
        var frame = infoAreaBounds
        // Baseline alignment with start label
        frame.origin.y += AgendaCell.subjectVerticalOffset
        frame.size.height -= AgendaCell.subjectVerticalOffset
        if !locationLabel.isHidden {
            frame.size.height -= AgendaCell.infoAreaSpacing + locationAreaBounds.height
        }
        // Currently subject can be 1 or 2 lines (subjectNumberOfLines), otherwise this code will have to be changed
        if frame.height < AgendaCell.subjectMaxHeight {
            frame.size.height = AgendaCell.subjectLineHeight
        }
        return frame
    }
    
    private func frameForLocationIcon() -> CGRect {
        var frame = locationAreaBounds
        frame.size.width = AgendaCell.locationIconSize
        return frame
    }
    
    private func frameForLocationLabel() -> CGRect {
        var frame = locationAreaBounds
        let offset = AgendaCell.locationIconSize + AgendaCell.locationAreaSpacing
        frame.origin.x += offset
        frame.size.width -= offset
        return frame
    }
#endif
    
    private func initLayout() {
    #if USE_CONSTRAINTS
        contentView.addSubview(container)
        container.fitIntoSuperview()
    #else
        contentView.addSubview(startLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(subjectLabel)
        contentView.addSubview(locationIcon)
        contentView.addSubview(locationLabel)
    #endif
    }
}
