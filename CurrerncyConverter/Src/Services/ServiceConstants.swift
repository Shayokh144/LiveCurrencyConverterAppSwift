//
//  ServiceConstants.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/27/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

class ServiceConstants{
    static let currencyListUrl : String = "http://api.currencylayer.com/list?access_key=4697f6150dc3379a6f1c21fafaf7e7ac"
    static let convertionRateUrl : String = "http://api.currencylayer.com/live?access_key=4697f6150dc3379a6f1c21fafaf7e7ac"
    static let currencyListTableName = "CurrencyListTable"
    static let conversionRateTableName = "CurrencyConversionRate"
}

enum ResponseType {
    case CURRENCY_LIST
    case CONVERTER_DATA
}
