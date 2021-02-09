//
//  StaticDataManager.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/26/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation

public class CollectionViewStaticDataProvider{
    static let textMapper : [String] = ["7", "8", "9", "", "4", "5", "6", "", "1","2", "3", "", "0", "."]
    static let imageMapper : [String] = ["", "", "", "backspace", "", "", "", "switchButton", "","", "", "deleteButton", "", ""]
    class func getTextForIndex(index : Int)-> String{
        if(index < textMapper.count){
            return textMapper[index]
        }
        return ""
    }
    
    class func getImageForIndex(index : Int)-> String{
        if(index < imageMapper.count){
            return imageMapper[index]
        }
        return ""
    }
}
