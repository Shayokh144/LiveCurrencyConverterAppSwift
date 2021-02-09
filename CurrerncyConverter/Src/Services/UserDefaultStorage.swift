//
//  UserDefaultStorage.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/29/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

class UserDefaultStorage{
    
    static let conversionrateDataInsertedKey = "conversionrateDataInsertedKey"
    static let currencyListDataInsertedKey = "currencyListDataInsertedKey"
    static let isAppLaunchedFirstTimeKey = "isAppLaunchedFirstTimeKey"
    static let apiAccessTimerValue = "apiAccessTimerValue"
    static let lastSelectedLeftCurrencyTypeKey = "lastSelectedLeftCurrencyTypeKey"
    static let lastSelectedRightCurrencyTypeKey = "lastSelectedRightCurrencyTypeKey"
    
    public func setIsDataSavedInCoreData (key : String, value : Bool){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func getIsDataSavedInCoreData (key : String)-> Bool{
        if (UserDefaults.standard.object(forKey: key) != nil){
            return UserDefaults.standard.bool(forKey: key)
        }
        return false
    }
    
    public func setApiAccessTimerValue (value : Int){
        UserDefaults.standard.set(value, forKey: UserDefaultStorage.apiAccessTimerValue)
    }
    
    public func getApiAccessTimerValue ()-> Int?{
        if (UserDefaults.standard.object(forKey: UserDefaultStorage.apiAccessTimerValue) != nil){
            return UserDefaults.standard.integer(forKey: UserDefaultStorage.apiAccessTimerValue)
        }
        return nil
    }
    
    public func setLastSelectedCurrency(forCurrencyTypeKey key : String, currencyTypeText : String){
        UserDefaults.standard.setValue(currencyTypeText, forKey: key)
    }
    
    public func getLastSelectedCurrency(forCurrencyTypeKey key: String)->String{
        if (UserDefaults.standard.object(forKey: key) != nil){
            return UserDefaults.standard.string(forKey: key) ?? "Select Currency"
        }
        return "Select Currency"
    }
}
