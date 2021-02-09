//
//  keyBoardGridManager.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/25/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import Foundation
import UIKit

class KeyBoardGridManager{
    var numOfColumns : Int  = 0
    var numOfRows : Int = 0
    
    class func getSizeForCell(collectionView : UICollectionView,indexPath : IndexPath)->CGSize{
        if (indexPath.row > 11){
            return CGSize(width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.height/4)
        }

        return CGSize(width: collectionView.bounds.size.width/4, height: collectionView.bounds.size.height/4)
    }
    
    class func getCell(collectionView : UICollectionView,indexPath : IndexPath)-> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyBoardCollectionViewCell.reuseId, for: indexPath) as! KeyBoardCollectionViewCell
        if((indexPath.row + 1) % 4  == 0){
            cell.backgroundColor = .lightGray
            cell.imageView.image = UIImage(named: CollectionViewStaticDataProvider.getImageForIndex(index: indexPath.row))
        }
        cell.label.text = CollectionViewStaticDataProvider.getTextForIndex(index: indexPath.row)
        return cell
    }
    
    class func setHighlightedColor(cell : UICollectionViewCell, indexPath : IndexPath){
        if((indexPath.row + 1) % 4  == 0){
            cell.backgroundColor = .black
        }
        else{
            cell.backgroundColor = .lightGray
        }
    }
    
    class func setUnHighlightedColor(cell : UICollectionViewCell,  indexPath : IndexPath){
        if((indexPath.row + 1) % 4  == 0){
            cell.backgroundColor = .lightGray
        }
        else{
            cell.backgroundColor = .black
        }
    }
}
