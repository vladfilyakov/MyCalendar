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
