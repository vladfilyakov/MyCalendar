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
    
    private static let horizontalMargin: CGFloat = 16
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds.insetBy(dx: AgendaHeaderView.horizontalMargin, dy: 0)
    }
}
