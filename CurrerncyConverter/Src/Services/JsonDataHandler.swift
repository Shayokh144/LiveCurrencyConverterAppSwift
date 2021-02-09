//
//  JsonDataHandler.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/26/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
// responsible for json parsing
struct CurrrencyListJsonDataModel : Decodable{
    let success : Bool?
    let terms : String?
    let privacy : String?
    let currencies : [String : String]?
}

struct CurrrencyRateJsonDataModel : Decodable{
    let success : Bool?
    let terms : String?
    let privacy : String?
    let timeStamp : Int?
    let source : String?
    let quotes : [String : Double]?
}


class JsonDataHandler{
    
    weak var jsonDataHandlerDelegate : JsonDataHandlerProtocol?
    
    public func parseCurrencyList (jsonData : Data)->[String : String]?{
        do{
            let currencyList: CurrrencyListJsonDataModel = try JSONDecoder().decode(CurrrencyListJsonDataModel.self, from: jsonData)
            print("currencyList success : \(currencyList.success ?? false)")
            return currencyList.currencies
        }
        catch{
            self.jsonDataHandlerDelegate?.onParsingErrorOccured()
            print("json decoding error in CurrencyList data...")
        }
        return nil
    }
    
    public func parseCurrencyRateData (jsonData : Data)->[String : Double]?{
        do{
            let currencyList: CurrrencyRateJsonDataModel = try JSONDecoder().decode(CurrrencyRateJsonDataModel.self, from: jsonData)
            print("currencyList success : \(currencyList.success ?? false)")
            return currencyList.quotes
        }
        catch{
            self.jsonDataHandlerDelegate?.onParsingErrorOccured()
            print("json decoding error in Rate Data...")
        }
        return nil
    }
}
