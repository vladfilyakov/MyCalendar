//
//  UIView+Extension.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/27/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

extension UIView {
    func fitIntoSuperview() {
        guard let container = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
}
