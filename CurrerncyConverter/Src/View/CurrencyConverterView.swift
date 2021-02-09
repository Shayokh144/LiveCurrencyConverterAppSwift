//
//  CurrencyConverterView.swift
//  CurrerncyConverter
//
//  Created by Abu Taher on 6/24/20.
//  Copyright © 2020 Abu Taher. All rights reserved.
//

import UIKit

class CurrencyConverterView: UIViewController {

    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var leftCurrencyLabel: UILabel!
    @IBOutlet weak var rightCurrencyLable: UILabel!
    @IBOutlet weak var keyBoardCollectionView: UICollectionView!
    @IBOutlet weak var leftCurrencyButton: UIButton!
    @IBOutlet weak var rightCurrencyButton: UIButton!
    
    @IBOutlet weak var leftCurrencyButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var leftCurrencyButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var leftCurrencyButtonTop: NSLayoutConstraint!
    @IBOutlet weak var leftCurrencyButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var rightCurrencyButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var rightCurrencyButtonTrailing: NSLayoutConstraint!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var currencyList = [CurrencyListModel]()
    var leftCurrencyButtonText : String = ""
    var rightCurrencyButtonText : String = ""
    var leftLabelValue : String = ""
    var rightlabelvalue : String = ""
    var presenter: CurrencyConverterViewToPresenterProtocol?
    var uiData : CurrencyUIDataModel  = CurrencyUIDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Currency Converter"
        self.setInitialUI()
        self.configureCollectionView()
        self.configureTableView()
        presenter?.getDataForView()
    }
    
    private func setInitialUI(){
        self.leftCurrencyButton.tag = CurrencyConverterUIUtils.leftCurrencyButtonTag
        self.rightCurrencyButton.tag = CurrencyConverterUIUtils.rightCurrencyButtonTag
        uiData.leftcurrencyText = "0"
        uiData.rightCurrencyText = "0"
        uiData.leftCurrencyType = ""
        uiData.rightCurrencyType = ""
        self.unitLabel.text = ""
        let defaultStorage = UserDefaultStorage()
        uiData.leftCurrencyType = defaultStorage.getLastSelectedCurrency(forCurrencyTypeKey: UserDefaultStorage.lastSelectedLeftCurrencyTypeKey)
        uiData.rightCurrencyType = defaultStorage.getLastSelectedCurrency(forCurrencyTypeKey: UserDefaultStorage.lastSelectedRightCurrencyTypeKey)
        self.setTextLabels(leftText: uiData.leftcurrencyText, rightText: uiData.rightCurrencyText)
        self.setButtonText(leftText: uiData.leftCurrencyType, rightText: uiData.rightCurrencyType)
        self.setButtonStyle()
    }
    
    private func setTextLabels(leftText : String, rightText : String){
        CurrencyConverterUIUtils.setPlainTextAndDynamicFontSizeOnLabel(label: self.leftCurrencyLabel, text: leftText)
        CurrencyConverterUIUtils.setPlainTextAndDynamicFontSizeOnLabel(label: self.rightCurrencyLable, text: rightText)
    }
    
    private func setButtonText(leftText : String, rightText : String){
        self.leftCurrencyButton.setTitle(leftText, for: .normal)
        self.rightCurrencyButton.setTitle(rightText, for: .normal)
    }
    private func setButtonStyle(){
        CurrencyConverterUIUtils.setButtonStyle(button: self.leftCurrencyButton)
        CurrencyConverterUIUtils.setButtonStyle(button: self.rightCurrencyButton)
    }
    
    private func configureCollectionView(){
        self.keyBoardCollectionView.delegate = self
        self.keyBoardCollectionView.dataSource = self
        self.keyBoardCollectionView.register(KeyBoardCollectionViewCell.loadNib, forCellWithReuseIdentifier: KeyBoardCollectionViewCell.reuseId)
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func leftCurrencyButtonAction(_ sender: Any) {
        selectedButton = leftCurrencyButton
        addTransparentView(frames: leftCurrencyButton.frame)
    }
    
    @IBAction func rightCurrencyButtonAction(_ sender: Any) {
        selectedButton = rightCurrencyButton
        addTransparentView(frames: rightCurrencyButton.frame)
    }
    
}

// MARK: PresenterToViewProtocol
extension CurrencyConverterView : CurrencyConverterPresenterToViewProtocol{
    func showNoActionPopup(titleText : String, messageText: String) {
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("ok action tapped..")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateViewAll(updatedData: CurrencyUIDataModel) {
        self.uiData = updatedData
        self.unitLabel.text = updatedData.uniLabelText
        self.setTextLabels(leftText: updatedData.leftcurrencyText, rightText: updatedData.rightCurrencyText)
        self.setButtonText(leftText: updatedData.leftCurrencyType, rightText: updatedData.rightCurrencyType)
    }
    
    func didReceiveUpdatedCurrencyList(updatedCurrencyList: [CurrencyListModel]) {
        self.currencyList = updatedCurrencyList
    }
    
    func updateLeftRightLabels(leftText: String, rightText: String) {
        self.uiData.leftcurrencyText = leftText
        self.uiData.rightCurrencyText = rightText
        self.setTextLabels(leftText: leftText, rightText: rightText)
    }
}

// MARK: UICollectionViewDataSource
extension CurrencyConverterView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = KeyBoardGridManager.getCell(collectionView: collectionView, indexPath: indexPath)
        return cell
    }
    
}

// MARK: UICollectionViewDelegate
extension CurrencyConverterView : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item : \(indexPath.row)")
        presenter?.didSelectCollectionViewItemAt(itemId: indexPath.row, currentData : uiData)
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell()
        KeyBoardGridManager.setHighlightedColor(cell: cell, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) ?? UICollectionViewCell()
        KeyBoardGridManager.setUnHighlightedColor(cell: cell, indexPath: indexPath)
        
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CurrencyConverterView : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return KeyBoardGridManager.getSizeForCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK:  UITableViewDelegate, UITableViewDataSource
extension CurrencyConverterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")//tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = currencyList[indexPath.row].currencyCode
        cell.detailTextLabel?.text = currencyList[indexPath.row].currencyName
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(currencyList[indexPath.row].currencyCode, for: .normal)
        if(selectedButton.tag == self.leftCurrencyButton.tag){
            uiData.leftCurrencyType = currencyList[indexPath.row].currencyCode
        }
        else{
            uiData.rightCurrencyType = currencyList[indexPath.row].currencyCode
        }
        presenter?.needUpdatedConversionData(currentData: uiData)
        removeTransparentView()
    }
}


// MARK:  DropDownMethods
extension CurrencyConverterView{
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CurrencyConverterUIUtils.getTableHeight(itemCount: self.currencyList.count, heightLeft: (self.view.frame.size.height - frames.origin.y)))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}

