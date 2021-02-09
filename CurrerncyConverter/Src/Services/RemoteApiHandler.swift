//
//  RemoteApiHandler.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/26/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
// Responsible for calling APIs

class RemoteApiHandler{
    var featchingTimer:Timer? = nil
    var FEATCHING_TIME_AMOUNT_IN_SECONDS = 30
    weak var jsonResponseDelegate: RemoteApiHandlerProtocol?
    
    init() {
        
    }
    
    public func callToApi(apiUrl : String, responsType : ResponseType){
        if(ReachabilityCenter.isConnectedToInternet()){
            guard let url = URL(string: apiUrl) else {
                // todo: url not found error
                print("url not found..")
                self.jsonResponseDelegate?.onApiErrorOccured()
                return
            }
            
            let task = URLSession.shared.dataTask(with: url){(data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        self.jsonResponseDelegate?.onApiErrorOccured()
                        return
                }
                self.jsonResponseDelegate?.didReceiveJsonResponseFromUrl(responseData: dataResponse, responseType : responsType)
            }
            task.resume()
        }
        else{
            //todo: no internet alert protocol
            self.jsonResponseDelegate?.onApiErrorOccured()
            print("no internet")
        }
    }
    
    
}
