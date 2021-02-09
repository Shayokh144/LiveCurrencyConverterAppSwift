//
//  KeyBoardCollectionViewCell.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import UIKit

class KeyBoardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupView()
    }
    
    private func setupView(){
        self.backgroundColor = .black
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    static var loadNib:UINib {
        return UINib.init(nibName: String(describing: KeyBoardCollectionViewCell.classForCoder()), bundle: nil)
    }
    
    static var reuseId:String {
        return String(describing: KeyBoardCollectionViewCell.classForCoder())
    }
}
