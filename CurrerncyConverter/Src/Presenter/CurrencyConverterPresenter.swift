//
//  CurrencyConverterPresenter.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

class CurrencyConverterPresenter{
    
    weak var view : CurrencyConverterPresenterToViewProtocol?
    var interector: CurrencyConverterPresenterToInteractorProtocol?
    var router: CurrencyConverterPresenterToRouterProtocol?
    var shouldShowInternetError = true
    private func getProcessedLeftText(currentLeftText : String , newItem : String)->String?{
        let newText = currentLeftText + newItem
        if newText.doubleValue != nil{
            return String(newText)
        }
        return nil
    }
    
    private func removeLeadingZero(currencyText : String) -> String{
        var leadingZeroRemovedText = currencyText
        var resultedText = leadingZeroRemovedText
        if(leadingZeroRemovedText.count >= 2){
            let firstChar = leadingZeroRemovedText.prefix(1)
            leadingZeroRemovedText = String(leadingZeroRemovedText.dropFirst(1))
            let seconChar = leadingZeroRemovedText.prefix(1)
            if(firstChar == "0" && seconChar != "."){
                resultedText = String(resultedText.dropFirst(1))
            }
        }
        return resultedText
    }
    
    private func getCurrencyUnitText(rightUnitText : String, leftCurrencyType: String, RightCurrencyType : String)-> String{
        var unitText = ""
        unitText.append("1 ")
        unitText.append(leftCurrencyType)
        unitText.append(" = ")
        unitText.append(rightUnitText)
        unitText.append(" ")
        unitText.append(RightCurrencyType)
        return unitText
    }
}

// MARK:  ViewToPresenterProtocol
extension CurrencyConverterPresenter : CurrencyConverterViewToPresenterProtocol{
    func needUpdatedConversionData(currentData: CurrencyUIDataModel) {
        interector?.doNewConversion(currentData: currentData)
    }
    
    func getDataForView() {
        interector?.fetchData()
    }
    
    func didSelectCollectionViewItemAt(itemId: Int, currentData : CurrencyUIDataModel) {
        var newData = currentData
        if((itemId + 1) % 4 != 0){
            if let newText = self.getProcessedLeftText(currentLeftText: currentData.leftcurrencyText, newItem: CollectionViewStaticDataProvider.getTextForIndex(index: itemId)){
                newData.leftcurrencyText = newText
                interector?.doNewConversion(currentData: newData)
            }
        }
        else{
            switch itemId {
            case CollectionViewButtonIdentifier.CrossButton.rawValue:
                print("cross button pressed")
                var processedText = String(newData.leftcurrencyText.dropLast(1))
                processedText = processedText.count == 0 ? "0" : processedText
                if processedText.doubleValue != nil{
                    newData.leftcurrencyText = processedText
                }
                interector?.doNewConversion(currentData: newData)
            case CollectionViewButtonIdentifier.ToggleButton.rawValue:
                print("Toggle button pressed")
                let tempBtnText = newData.leftCurrencyType
                newData.leftCurrencyType = newData.rightCurrencyType
                newData.rightCurrencyType = tempBtnText
                interector?.doNewConversion(currentData: newData)
            case CollectionViewButtonIdentifier.DeleteButton.rawValue:
                print("Delete button pressed")
                newData.leftcurrencyText = "0"
                interector?.doNewConversion(currentData: newData)
            default:
                print("no button pressed")
            }
        }
    }
    
}


// MARK:  InteractorToPresenterProtocol
extension CurrencyConverterPresenter : CurrencyConverterInteractorToPresenterProtocol{
    
    func noInternetErrorOccured() {
        if (self.shouldShowInternetError){
            self.shouldShowInternetError = false
            view?.showNoActionPopup(titleText: "No Internet", messageText: "To get latest currency rates, please connect your phone to internet")
        }
        
    }
    
    func didFinishNewConversion(convertedData: CurrencyUIDataModel) {
        var newData = convertedData
        newData.leftcurrencyText = self.removeLeadingZero(currencyText: convertedData.leftcurrencyText)
        newData.rightCurrencyText = self.removeLeadingZero(currencyText: convertedData.rightCurrencyText)
        newData.uniLabelText = self.getCurrencyUnitText(rightUnitText: convertedData.rightUnitValue, leftCurrencyType: convertedData.leftCurrencyType, RightCurrencyType: convertedData.rightCurrencyType)
        view?.updateViewAll(updatedData: newData)
    }
    
    func didReceiveCurrencyList(currencyList: [CurrencyListModel]) {
        view?.didReceiveUpdatedCurrencyList(updatedCurrencyList: currencyList)
    }
}

extension CurrencyConverterPresenter : CurrencyConverterRouterToPresenterProtocol{
    
}
