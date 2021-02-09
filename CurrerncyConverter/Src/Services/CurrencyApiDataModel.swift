//
//  CurrencyApiDataModel.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/27/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

struct CurrencyListModel {
    var currencyCode : String = ""
    var currencyName : String = ""
}

struct ConversionRateModel{
    var currencyCode : String = ""
    var currencyRate : Double = 0.0
}


public class CurrencyApiDataModel{
    class func convertToCurrencyListModel(currencyList: [String : String])-> [CurrencyListModel]{
        var dataArray = [CurrencyListModel]()
        var data : CurrencyListModel = CurrencyListModel()
        let sortedList = currencyList.sorted{$0.key < $1.key}
        for (key, value) in sortedList{
            data.currencyCode = key
            data.currencyName = value
            dataArray.append(data)
        }
        return dataArray
    }
    
    class func convertToCurrencyRateModel(apiRateData : [String : Double])->[String : Double]{
        var convertedData = [String : Double]()
        for(key, value) in apiRateData{
            if(key.count > 3){
                let newKey = String(key.dropFirst(3))
                convertedData[newKey] = value
            }
        }
        return convertedData
    }
}
