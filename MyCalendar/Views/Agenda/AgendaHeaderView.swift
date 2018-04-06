//
//  AgendaHeaderView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 4/5/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class AgendaHeaderView: UITableViewHeaderFooterView {
    static let identifier = "AgendaHeaderView"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds.insetBy(dx: layoutMargins.left, dy: 0)
    }
}
