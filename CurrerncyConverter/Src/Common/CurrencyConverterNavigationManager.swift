//
//  CurrencyConverterNavigationManager.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
import UIKit

class CurrencyConverterNavigationManager : NSObject{
    
    var navigationController : UINavigationController?
    var window: UIWindow?
    
    init(_ window: UIWindow?){
        if(window == nil){
            self.window = UIWindow(frame:UIScreen.main.bounds)
        }
        else{
            self.window = window
        }
        
    }
    
    public func getCurrentNavigationController()->UINavigationController{
        return navigationController ?? UINavigationController()
    }
    
    public func setInitialView(){
        self.navigationController = UINavigationController(rootViewController: CurrencyConverterRouter.createModule())
        self.navigationController?.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
    }
}
