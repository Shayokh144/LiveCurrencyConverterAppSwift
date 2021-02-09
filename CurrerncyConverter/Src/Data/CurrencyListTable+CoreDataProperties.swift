//
//  CurrencyListTable+CoreDataProperties.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/28/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrencyListTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyListTable> {
        return NSFetchRequest<CurrencyListTable>(entityName: "CurrencyListTable")
    }

    @NSManaged public var currencyName: String?
    @NSManaged public var currencyCode: String?

}
