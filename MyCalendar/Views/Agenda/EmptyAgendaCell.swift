//
//  EmptyAgendaCell.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 4/5/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class EmptyAgendaCell: UITableViewCell {
    static let identifier = "EmptyAgendaCell"
    
    static var height: CGFloat {
        // Match for standard height
        return 2 * verticalMargin + ceil(font.lineHeight)
    }
    private static let horizontalMargin: CGFloat = 16
    private static let verticalMargin: CGFloat = 13
    
    private static let font = UIFont.preferredFont(forTextStyle: .subheadline)
    private static let textColor = UIColor(red: 0.65, green: 0.66, blue: 0.67, alpha: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.text = NSLocalizedString("Events.None", comment: "")
        textLabel?.textColor = EmptyAgendaCell.textColor
        textLabel?.font = EmptyAgendaCell.font
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = contentView.bounds.insetBy(dx: EmptyAgendaCell.horizontalMargin, dy: 0)
    }
}
