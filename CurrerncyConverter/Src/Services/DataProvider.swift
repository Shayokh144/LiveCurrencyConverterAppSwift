//
//  DataProvider.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/27/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

class DataProvider{
    
    var currencyList : [CurrencyListModel]?
    var currencyConversionRateBasedUSD : [String : Double]?
    let staticData : StaticDataProvider?
    weak var dataProviderDelegate : DataProviderProtocol?
    let dataManager = DBManager.shared
    let INTERNET_SCHEDULER_IN_SECONDS = 10
    let DATA_FETCHING_TIMER_IN_SECONDS = 180
    var dataFeatchingTimer:Timer? = nil
    let apiFetchingTimeLimitInMinutes = 3
    init() {
        staticData = StaticDataProvider()
        dataManager.dbManagerDelegate = self
    }
    
    public func getCurrencyListData()->[CurrencyListModel]?{
        if let ownData = currencyList{
            return ownData
        }
        else{
            let defaultStorage = UserDefaultStorage()
            if(defaultStorage.getIsDataSavedInCoreData(key: UserDefaultStorage.currencyListDataInsertedKey)){
                //async operation
                dataManager.getCurrencyListData()
            }
            //else{
                //async operation
                //self.fetchApiData(apiUrl: ServiceConstants.currencyListUrl, responseType: .CURRENCY_LIST)
            //}
        }
        return CurrencyApiDataModel.convertToCurrencyListModel(currencyList : staticData?.getCurrencyList() ?? [:])
    }
    
    public func getCurrencyRateData()-> [String : Double]?{
        if let ownData = currencyConversionRateBasedUSD{
            self.setTimerForNextFetch()
            return ownData
        }
        else{
            let defaultStorage = UserDefaultStorage()
            if(defaultStorage.getIsDataSavedInCoreData(key: UserDefaultStorage.conversionrateDataInsertedKey)){
                self.setTimerForNextFetch()
                //async operation
                dataManager.getConversionRateData()
            }
            else{
                //async operation
                if(!ReachabilityCenter.isConnectedToInternet()){
                    // not connected to internet
                    dataProviderDelegate?.notConnectedToInternetError()
                    self.startFeatchingTimer(timeInterval: INTERNET_SCHEDULER_IN_SECONDS)
                }
                else{
                    self.callForData()
                }
                
            }
        }
        return staticData?.getcurrencyConversionRateData()
    }
    
    private func fetchApiData(apiUrl : String, responseType : ResponseType){
        let remoteApiHandler = RemoteApiHandler()
        remoteApiHandler.jsonResponseDelegate = self
        remoteApiHandler.callToApi(apiUrl: apiUrl, responsType: responseType)
    }
    
    private func stopFeatchingTimer(){
        self.dataFeatchingTimer?.invalidate()
        self.dataFeatchingTimer = nil
    }
    
    private func startFeatchingTimer(timeInterval : Int){
        DispatchQueue.main.async{
            self.stopFeatchingTimer()
            self.dataFeatchingTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(self.onFetchingTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    private func isApiReadyToFetch()-> Bool{
        let defaultStorage = UserDefaultStorage()
        guard let lastUpdateTime = defaultStorage.getApiAccessTimerValue() else { return true }
        let date = NSDate()
        let currentTime = Int(date.timeIntervalSinceReferenceDate)
        let difMinutes = (currentTime - lastUpdateTime) / 60
        print("isApiReadyToFetch difmin = \(difMinutes)")
        return difMinutes > apiFetchingTimeLimitInMinutes
    }
    
    private func updateApiDataFetchingTime(){
        let date = NSDate()
        let lastUpdatedTime = Int(date.timeIntervalSinceReferenceDate)
        let defaultStorage = UserDefaultStorage()
        defaultStorage.setApiAccessTimerValue(value: lastUpdatedTime)
        // timer to fetch again after 30 min
        self.startFeatchingTimer(timeInterval: DATA_FETCHING_TIMER_IN_SECONDS)
    }
    
    private func setTimerForNextFetch(){
        let defaultStorage = UserDefaultStorage()
        if let lastupdatedTime = defaultStorage.getApiAccessTimerValue(){
            let date = NSDate()
            let currentTime = Int(date.timeIntervalSinceReferenceDate)
            let remainingTime = lastupdatedTime + DATA_FETCHING_TIMER_IN_SECONDS - currentTime + 5
            print("remainin time to fetch api : \(remainingTime)")
            if(remainingTime > 0){
                self.startFeatchingTimer(timeInterval: remainingTime)
            }
            else{
                self.callForData()
            }
        }
        else{
            self.callForData()
        }
    }
    private func callForData(){
        if(ReachabilityCenter.isConnectedToInternet()){
            //async task
            self.fetchApiData(apiUrl: ServiceConstants.convertionRateUrl, responseType: .CONVERTER_DATA)
        }
        else{
            self.startFeatchingTimer(timeInterval: INTERNET_SCHEDULER_IN_SECONDS)
        }
    }
    
    @objc fileprivate func onFetchingTimeOut(){
        print("onFetchingTimeOut data provider fetching timer ends ...")
        if(!ReachabilityCenter.isConnectedToInternet()){
            print("onFetchingTimeOut data provider no internet connection")
            self.startFeatchingTimer(timeInterval: INTERNET_SCHEDULER_IN_SECONDS)
        }
        else{
            if(self.isApiReadyToFetch()){
                self.callForData()
            }
            else{
                self.setTimerForNextFetch()
            }
        }
    }
}

// MARK: RemoteApiHandlerProtocol
extension DataProvider : RemoteApiHandlerProtocol{
    func onApiErrorOccured() {
        self.callForData()
    }
    
    func didReceiveJsonResponseFromUrl(responseData: Data, responseType : ResponseType) {
        let jsonHandlerObj = JsonDataHandler()
        jsonHandlerObj.jsonDataHandlerDelegate = self
        
        switch responseType {
        case .CURRENCY_LIST:
            if let currencyList = jsonHandlerObj.parseCurrencyList(jsonData: responseData){
                print(currencyList)
                dataProviderDelegate?.updateCurrencyList(newCurrencyList: CurrencyApiDataModel.convertToCurrencyListModel(currencyList : currencyList))
                //dataManager.saveCurrencyListData(currencyList: currencyList)
            }
        case .CONVERTER_DATA:
            print("live converter data appears....")
            if let converterDataJ = jsonHandlerObj.parseCurrencyRateData(jsonData: responseData){
                var converterData = converterDataJ
                converterData = CurrencyApiDataModel.convertToCurrencyRateModel(apiRateData: converterData)
                print("converterData :\n\(converterData)")
                self.currencyConversionRateBasedUSD = converterData
                self.updateApiDataFetchingTime()
                dataProviderDelegate?.updateConverterValues(newUsdBasedConverterValues: converterData)
                //async operation
                dataManager.saveConversionRateData(coversionData: converterData)
                //async operation to fetch list
                self.fetchApiData(apiUrl: ServiceConstants.currencyListUrl, responseType: .CURRENCY_LIST)
            }
            else{
                self.callForData()
            }
        }

    }
    
}

// MARK: DBManagerProtocol
extension DataProvider : DBManagerProtocol{
    func didReceiveCurrencyConversionRateFromCoreDB(conversionRateList: [String : Double]) {
        dataProviderDelegate?.updateConverterValues(newUsdBasedConverterValues: conversionRateList)
    }
    
    func didReceiveCurrencyListFromCoreDB(currencyList: [CurrencyListModel]) {
        if(currencyList.count > 0){
            print("didReceiveCurrencyListFromCoreDB ..")
            dataProviderDelegate?.updateCurrencyList(newCurrencyList: currencyList)
        }
        else{
            print("didReceiveCurrencyListFromCoreDB no data found..")
        }
    }
}

extension DataProvider : JsonDataHandlerProtocol{
    func onParsingErrorOccured() {
        self.callForData()
    }
}
