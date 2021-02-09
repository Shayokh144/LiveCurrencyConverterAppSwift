//
//  CurrencyConverterEntity.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

struct CurrencyUIDataModel{
    var leftcurrencyText : String = ""
    var rightCurrencyText : String = ""
    var leftCurrencyType : String = ""
    var rightCurrencyType : String = ""
    var uniLabelText : String = ""
    var rightUnitValue : String = ""
}

enum CollectionViewButtonIdentifier: Int{
    case CrossButton = 3
    case ToggleButton = 7
    case DeleteButton = 11
}

class CurrencyConverterEntity{
    static let shared = CurrencyConverterEntity()
    var currencyDataModel : CurrencyUIDataModel = CurrencyUIDataModel()
    
    private init(){}
    
    public func getEntity()->CurrencyUIDataModel{
        return currencyDataModel
    }
    
    public func setEntity(newEntity : CurrencyUIDataModel){
        currencyDataModel = newEntity
    }
}

