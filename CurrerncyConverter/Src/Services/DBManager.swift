//
//  DBManager.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/28/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBManager{
    
    static let shared = DBManager()
    private var appDelegate : AppDelegate?
    private var context : NSManagedObjectContext?
    private var currencyListTableData = [CurrencyListTable]()
    private var containerName = "CurrencyConverter"
    weak var dbManagerDelegate : DBManagerProtocol?
    var persistanContainer : NSPersistentContainer?
    
    private init() {
        DispatchQueue.main.async {
            self.appDelegate = UIApplication.shared.delegate as? AppDelegate
            self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        persistanContainer = NSPersistentContainer(name: containerName)
        persistanContainer?.loadPersistentStores{(_, error) in
            if let error = error{
                print("failed to load core data for currencyListTableData: \(error)")
            }
        }
    }
    
    
    public func saveCurrencyListData(currencyList : [String : String]){
        self.persistanContainer?.performBackgroundTask{(context) in
            for (key, value) in currencyList{
                let cListObj = CurrencyListTable(context: context)
                cListObj.currencyCode = key
                cListObj.currencyName = value
            }
            do{
                try context.save()
                print("successfully save to db currencyListTableData")
                let defaultStorage = UserDefaultStorage()
                defaultStorage.setIsDataSavedInCoreData(key: UserDefaultStorage.currencyListDataInsertedKey, value: true)
            }
            catch{
                print("can't save currencyListTableData: \(error)")
            }
        }
        
    }

    
    public func saveConversionRateData(coversionData : [String : Double]){
        self.persistanContainer?.performBackgroundTask{(context) in
            for (key, value) in coversionData{
                let cDataObj = CurrencyConversionRate(context: context)
                cDataObj.currencyCode = key
                cDataObj.currencyRate = value
            }
            do{
                try context.save()
                print("successfully save to db CurrencyConversionRate")
                let defaultStorage = UserDefaultStorage()
                defaultStorage.setIsDataSavedInCoreData(key: UserDefaultStorage.conversionrateDataInsertedKey, value: true)
            }
            catch{
                print("can't save CurrencyConversionRate: \(error)")
            }
        }
        
    }
    
    public func getCurrencyListData(){
        var dataArray = [String : String]()
        var key = ""
        var value = ""
        let privateManageObjectContext = persistanContainer?.newBackgroundContext()
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: ServiceConstants.currencyListTableName)
        let asyncfetchReq = NSAsynchronousFetchRequest(fetchRequest : fetchReq){asyncFetchResult in
            guard let result = asyncFetchResult.finalResult as? [CurrencyListTable] else {return}
            DispatchQueue.main.async{
                for obj in result{
                    let objId = obj.objectID
                    guard let qSafeObj = self.context?.object(with: objId) as? CurrencyListTable else {continue}
                    if let currencyName = qSafeObj.value(forKey: "currencyName") as? String{
                        value = currencyName
                    }
                    if let currencyCode = qSafeObj.value(forKey: "currencyCode") as? String{
                        key = currencyCode
                    }
                    dataArray[key] = value
                }
                self.dbManagerDelegate?.didReceiveCurrencyListFromCoreDB(currencyList: CurrencyApiDataModel.convertToCurrencyListModel(currencyList: dataArray))
            }
            
        }
        
        do{
            try privateManageObjectContext?.execute(asyncfetchReq)
        }
        catch let error{
            print("NSAsynchronousFetchRequest error : \(error)")
        }
    }
    
    public func getConversionRateData(){
        var dataArray = [String : Double]()
        var currencyRateC : Double = 0.0
        var currencyCodeC : String = ""
        let privateManageObjectContext = persistanContainer?.newBackgroundContext()
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: ServiceConstants.conversionRateTableName)
        let asyncfetchReq = NSAsynchronousFetchRequest(fetchRequest : fetchReq){asyncFetchResult in
            guard let result = asyncFetchResult.finalResult as? [CurrencyConversionRate] else {return}
            DispatchQueue.main.async{
                for obj in result{
                    let objId = obj.objectID
                    guard let qSafeObj = self.context?.object(with: objId) as? CurrencyConversionRate else {continue}
                    if let currencyRate = qSafeObj.value(forKey: "currencyRate") as? Double{
                        currencyRateC = currencyRate
                    }
                    if let currencyCode = qSafeObj.value(forKey: "currencyCode") as? String{
                        currencyCodeC = currencyCode
                    }
                    dataArray[currencyCodeC] = currencyRateC
                }
                self.dbManagerDelegate?.didReceiveCurrencyConversionRateFromCoreDB(conversionRateList: dataArray)
            }
            
        }
        
        do{
            try privateManageObjectContext?.execute(asyncfetchReq)
        }
        catch let error{
            print("NSAsynchronousFetchRequest error : \(error)")
        }
    }

}
