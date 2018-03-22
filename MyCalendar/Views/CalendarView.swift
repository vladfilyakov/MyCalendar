//
//  CalendarView.swift
//  MyCalendar
//
//  Created by Vladislav Filyakov on 3/21/18.
//  Copyright © 2018 Vlad Filyakov. All rights reserved.
//

import UIKit

class CalendarView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = .orange   //!!!
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    var numberOfWeeks: Int = 5 {
        didSet {
            numberOfWeeks = max(1, numberOfWeeks)
            if numberOfWeeks != oldValue {
                //!!!
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        //!!!
        return CGSize(width: UIViewNoIntrinsicMetric, height: CGFloat(numberOfWeeks) * 40)
    }
    
    func setNumberOfWeeks(_ numberOfWeeks: Int, animated: Bool) {
        self.numberOfWeeks = numberOfWeeks
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}
