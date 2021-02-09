//
//  ServiceProtocols.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/26/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

protocol RemoteApiHandlerProtocol: class {
    func didReceiveJsonResponseFromUrl(responseData : Data, responseType : ResponseType)
    func onApiErrorOccured()
}
protocol JsonDataHandlerProtocol: class {
    func onParsingErrorOccured()
}

protocol DataProviderProtocol: class {
    func updateCurrencyList(newCurrencyList : [CurrencyListModel])
    func updateConverterValues(newUsdBasedConverterValues : [String : Double])
    func notConnectedToInternetError()
}

protocol DBManagerProtocol : class {
    func didReceiveCurrencyListFromCoreDB(currencyList : [CurrencyListModel])
    func didReceiveCurrencyConversionRateFromCoreDB(conversionRateList : [String : Double])
}
