//
//  CurrencyConversionRate+CoreDataProperties.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/28/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrencyConversionRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyConversionRate> {
        return NSFetchRequest<CurrencyConversionRate>(entityName: "CurrencyConversionRate")
    }

    @NSManaged public var currencyRate: Double
    @NSManaged public var currencyCode: String

}
