//
//  Extensions.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/26/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

extension String{
    struct DNumberFormatter {
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        return DNumberFormatter.instance.number(from: self)?.doubleValue
    }
}

extension Date{
    static func - (curDate: Date , prevDate : Date) -> TimeInterval{
        return curDate.timeIntervalSinceReferenceDate - prevDate.timeIntervalSinceReferenceDate
    }
}
