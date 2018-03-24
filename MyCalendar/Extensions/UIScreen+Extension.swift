//
//  UIScreen+Extension.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/24/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

extension UIScreen {
    func roundToDevicePixels(_ value: CGFloat) -> CGFloat {
        return ceil(value * scale) / scale
    }
}
