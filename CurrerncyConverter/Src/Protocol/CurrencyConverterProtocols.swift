//
//  CurrencyConverterProtocols.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

//View ->Presenter
protocol CurrencyConverterViewToPresenterProtocol:class {
    func didSelectCollectionViewItemAt(itemId : Int, currentData : CurrencyUIDataModel)
    func getDataForView()
    func needUpdatedConversionData(currentData : CurrencyUIDataModel)
}

//Presenter -> View
protocol CurrencyConverterPresenterToViewProtocol:class {
    func updateLeftRightLabels(leftText : String, rightText: String)
    func didReceiveUpdatedCurrencyList(updatedCurrencyList : [CurrencyListModel])
    func updateViewAll(updatedData : CurrencyUIDataModel)
    func showNoActionPopup(titleText : String, messageText: String)
}

//Presenter -> Router
protocol CurrencyConverterPresenterToRouterProtocol:class {
}

//Router -> Presenter
protocol CurrencyConverterRouterToPresenterProtocol:class {
    
}

//Presenter -> Interactor
protocol CurrencyConverterPresenterToInteractorProtocol:class {
    func fetchData()
    func doNewConversion(currentData : CurrencyUIDataModel)
}

//Interactor -> Presenter
protocol CurrencyConverterInteractorToPresenterProtocol:class {
    func didReceiveCurrencyList(currencyList : [CurrencyListModel])
    func didFinishNewConversion(convertedData : CurrencyUIDataModel)
    func noInternetErrorOccured()
}

