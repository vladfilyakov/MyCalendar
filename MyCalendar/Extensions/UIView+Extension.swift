//
//  UIView+Extension.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/27/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

extension UIView {
    func fitIntoSuperview(usingMargins: Bool = false) {
        guard let container = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal,
                           toItem: container, attribute: usingMargins ? .leadingMargin : .leading,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                           toItem: container, attribute: usingMargins ? .trailingMargin : .trailing,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                           toItem: container, attribute: usingMargins ? .topMargin : .top,
                           multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                           toItem: container, attribute: usingMargins ? .bottomMargin : .bottom,
                           multiplier: 1, constant: 0).isActive = true

    }
    
    func fitSubviewsHorizontally(_ subviews: [UIView]) {
        var frame = bounds
        for i in 0..<subviews.count {
            let offset = UIScreen.main.roundToDevicePixels(CGFloat(i + 1) / CGFloat(subviews.count) * bounds.width)
            frame.size.width = offset - frame.origin.x
            subviews[i].frame = frame
            frame.origin.x = frame.maxX
        }
    }
}
