//
//  SearchTextField.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

class SearchTextField: NSObject, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Variables
    var textField: UITextField!
    var tableView: UITableView!
    var delegateMethods: ProtocolViewController!
    var array: [TrainStation] = []
    var filteredArray: [TrainStation] = []
    var selected = false
    var selectedItem: TrainStation?
    
    
    //MARK: - Init methods
    init(textField: UITextField, tableView: UITableView, protocol delegateMethods: ProtocolViewController) {
        super.init()
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tableView.isHidden = true
        
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.textField = textField
        self.tableView = tableView
        self.delegateMethods = delegateMethods
    }
    
    
    //MARK: - TextField methods
    func textFieldDidChange(_ textField: UITextField) {
        self.selected = false
        self.delegateMethods.itemDidChange()
        if textField.text == nil || textField.text == "" {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
            self.filteredArray = array.filter({ trainStation in
                if trainStation.name.lowercased().removeAccents().contains(textField.text!.lowercased().removeAccents()) {
                    return true
                } else {
                    return false
                }
            })
            self.tableView.reloadData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldFindItem(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldFindItem(textField)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldFindItem(_ textField: UITextField) {
        self.tableView.isHidden = true
        if let text = textField.text?.lowercased().removeAccents() {
            for item in filteredArray {
                if item.name.lowercased().removeAccents() == text {
                    textField.text = item.name
                    self.selected = true
                    self.selectedItem = item
                    self.delegateMethods.itemDidChange()
                    break
                }
            }
        }
    }
    
    //MARK: - TableView methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.filteredArray[indexPath.row]
        self.textField.text = item.name
        self.selected = true
        self.selectedItem = item
        self.textField.resignFirstResponder()
        tableView.isHidden = true
        self.delegateMethods.itemDidChange()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
        }
        cell!.textLabel?.text = self.filteredArray[indexPath.row].name
        return cell!
    }
}

extension String {
    func removeAccents() -> String {
        return self
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "ł", with: "l")
    }
}
