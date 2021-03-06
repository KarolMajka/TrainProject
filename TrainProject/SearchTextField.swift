//
//  SearchTextField.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

class SearchTextField: NSObject {
    
    //MARK: - Variables
    fileprivate var textField: [UITextField] = []
    fileprivate var tableView: UITableView!
    fileprivate var delegateMethods: MainViewControllerDelegate!
    public var array: [TrainStation] = []
    public var filteredArray: [TrainStation] = []
    public var selected = [false, false]
    public var selectedItem: [TrainStation?] = [nil, nil]
    
    
    //MARK: - Initialization
    init(first firstTextField: UITextField, second secondTextField: UITextField, tableView: UITableView, delegate: MainViewControllerDelegate) {
        super.init()
        firstTextField.tag = 100
        secondTextField.tag = 101
        firstTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        secondTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableView.isHidden = true
        
        firstTextField.delegate = self
        secondTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.textField.append(firstTextField)
        self.textField.append(secondTextField)
        self.tableView = tableView
        self.delegateMethods = delegate
    }
}


//MARK: - Helpers
extension SearchTextField {
    func textFieldDidChange(_ textField: UITextField) {
        self.selected[textField.tag-100] = false
        self.delegateMethods.itemDidChange()
        self.updateTableView(textField)
    }
    
    fileprivate func updateTableView(_ textField: UITextField) {
        guard let text = textField.text?.lowercased().removeAccents() else {
            self.tableView.isHidden = true
            return
        }
        if text == "" {
            self.filteredArray = self.array.filter({$0.recentlySelected})
        } else {
            self.filteredArray = self.array.filter({ trainStation in
                if trainStation.name.lowercased().removeAccents().contains(text) {
                    return true
                } else {
                    return false
                }
            })
        }
        if self.filteredArray.count == 0 {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    fileprivate func textFieldFindItem(_ textField: UITextField) {
        self.tableView.isHidden = true
        if let text = textField.text?.lowercased().removeAccents() {
            for item in filteredArray {
                if item.name.lowercased().removeAccents() == text {
                    textField.text = item.name
                    self.selected[textField.tag-100] = true
                    self.selectedItem[textField.tag-100] = item
                    self.delegateMethods.itemDidChange()
                    break
                }
            }
        }
    }
    
    fileprivate func getCurrentTextField() -> UITextField {
        if self.textField[0].isFirstResponder {
            return self.textField[0]
        } else {
            return self.textField[1]
        }
    }
}


//MARK: - UITextFieldDelegate
extension SearchTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateTableView(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldFindItem(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldFindItem(textField)
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - UITableViewDelegate
extension SearchTextField: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.filteredArray[indexPath.row]
        let textField = self.getCurrentTextField()
        textField.text = item.name
        self.selected[textField.tag-100] = true
        self.selectedItem[textField.tag-100] = item
        textField.resignFirstResponder()
        tableView.isHidden = true
        self.delegateMethods.itemDidChange()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
}


//MARK: - UITableViewDataSource
extension SearchTextField: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
        }
        cell!.textLabel?.text = self.filteredArray[indexPath.row].name
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell!.textLabel?.adjustsFontSizeToFitWidth = true
        return cell!
    }
}
