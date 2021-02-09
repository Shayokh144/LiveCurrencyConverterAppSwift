//
//  CurrencyConverterInteractor.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
class CurrencyConverterInteractor{
    weak var presenter: CurrencyConverterInteractorToPresenterProtocol?
    var dataProvider : DataProvider
    var conversionRateDict = [String : Double]()
    
    init() {
        dataProvider = DataProvider()
        dataProvider.dataProviderDelegate = self
    }
    
    private func sendCurrencyListDataToPresenter(currencyList: [CurrencyListModel]){
        presenter?.didReceiveCurrencyList(currencyList: currencyList)
    }
    
    private func isValidData(data : CurrencyUIDataModel)-> Bool{
        return (data.leftcurrencyText.count > 0 && data.leftCurrencyType.count > 0 && data.rightCurrencyText.count > 0 && data.rightCurrencyType.count > 0)
    }
    
    private func getConvertedCurrency(leftRate : Double, rightRate : Double, multiplier : Double)->Double{
        if(leftRate != 0 && rightRate >= 0 && multiplier >= 0){
            return (rightRate / leftRate) * multiplier
        }
        return 0.0
    }
    
    private func getCurrencyUnitValue(leftRate : Double, rightRate : Double)->String{
        if(leftRate != 0 && rightRate >= 0){
            let result = (rightRate / leftRate)
            return String(format: "%.3f",result)
        }
        return "0"
    }
    
    private func updateLastSelectedCurrencyType(leftCurrencyType: String, rightCurrencyType : String){
        let defaultStorage = UserDefaultStorage()
        defaultStorage.setLastSelectedCurrency(forCurrencyTypeKey: UserDefaultStorage.lastSelectedLeftCurrencyTypeKey, currencyTypeText: leftCurrencyType)
        defaultStorage.setLastSelectedCurrency(forCurrencyTypeKey: UserDefaultStorage.lastSelectedRightCurrencyTypeKey, currencyTypeText: rightCurrencyType)
    }
}

extension CurrencyConverterInteractor : CurrencyConverterPresenterToInteractorProtocol{
    
    func doNewConversion(currentData: CurrencyUIDataModel) {
        var newData = currentData
        if isValidData(data: currentData){
            if let leftCurrencyRate = conversionRateDict[currentData.leftCurrencyType] , let rightCurrencyRate = conversionRateDict[currentData.rightCurrencyType]{
                if let leftMultiplayer = currentData.leftcurrencyText.doubleValue{
                    let result = self.getConvertedCurrency(leftRate: leftCurrencyRate, rightRate: rightCurrencyRate, multiplier: leftMultiplayer)
                    newData.rightCurrencyText = result == 0.0 ? "0" : String(format: "%.3f",result)
                    print("result : \(result)")
                    newData.rightUnitValue = self.getCurrencyUnitValue(leftRate: leftCurrencyRate, rightRate: rightCurrencyRate)
                    self.updateLastSelectedCurrencyType(leftCurrencyType: newData.leftCurrencyType, rightCurrencyType: newData.rightCurrencyType)
                    presenter?.didFinishNewConversion(convertedData: newData)
                }
                print("left rate:\(leftCurrencyRate)")
                print("right rate:\(rightCurrencyRate)")
            }
        }
    }
    
    func fetchData() {
        print("fetch data ..")
        if let newRate = dataProvider.getCurrencyRateData(){
            self.conversionRateDict = newRate
        }
        if let currencyList = dataProvider.getCurrencyListData(){
            self.sendCurrencyListDataToPresenter(currencyList: currencyList)
        }
        

    }
}

// MARK: DataProviderProtocol
extension CurrencyConverterInteractor : DataProviderProtocol{
    func notConnectedToInternetError() {
        presenter?.noInternetErrorOccured()
    }
    
    func updateCurrencyList(newCurrencyList: [CurrencyListModel]) {
        self.sendCurrencyListDataToPresenter(currencyList: newCurrencyList)
    }
    
    func updateConverterValues(newUsdBasedConverterValues: [String : Double]) {
        self.conversionRateDict = newUsdBasedConverterValues
    }
    
    
}
