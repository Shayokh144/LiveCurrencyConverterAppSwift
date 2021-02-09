//
//  CurrencyConverterRouter.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
import UIKit

class CurrencyConverterRouter{
    
    static weak var presenter: CurrencyConverterRouterToPresenterProtocol?
    
    class func createModule()-> UIViewController{
        let viewController = CurrencyConverterView.init(nibName: "CurrencyConverterView", bundle: nil)
        let presenter = CurrencyConverterPresenter()
        let interactor = CurrencyConverterInteractor()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = CurrencyConverterRouter.self()
        presenter.interector = interactor
        interactor.presenter = presenter
        CurrencyConverterRouter.presenter = presenter
        return viewController
    }
}

extension CurrencyConverterRouter : CurrencyConverterPresenterToRouterProtocol{
    
}
