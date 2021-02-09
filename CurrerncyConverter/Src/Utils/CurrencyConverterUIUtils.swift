//
//  CurrencyConverterUIUtils.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/25/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
import UIKit

public class CurrencyConverterUIUtils{
    
    static let RATIO = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) / 414.0
    static let leftCurrencyButtonTag = 101
    static let rightCurrencyButtonTag = 202
    
    class func setPlainTextAndDynamicFontSizeOnLabel(label : UILabel, text : String){
        label.text = text
        let textLength = text.count
        if(textLength < 4){
            label.font = UIFont.systemFont(ofSize: 24)
        }
        else if(textLength < 10){
            label.font = UIFont.systemFont(ofSize: 20)
        }
        else if(textLength < 16){
            label.font = UIFont.systemFont(ofSize: 16)
        }
        else{
            label.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    class func getTableHeight(itemCount : Int, heightLeft : CGFloat)-> CGFloat{
        let itemHeight : CGFloat = (CGFloat(itemCount) * 50.0)
        if(itemHeight < heightLeft){
            return itemHeight
        }
        return (heightLeft - 100.0)
    }
    
    class func setButtonStyle(button : UIButton){
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
    }
    
    static func multiplyWithScreenRatio(constraint: NSLayoutConstraint) {
        constraint.constant = constraint.constant * CurrencyConverterUIUtils.RATIO
    }
}
