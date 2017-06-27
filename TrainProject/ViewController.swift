//
//  ViewController.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ProtocolViewController {

    
    //MARK: - IBOutlets
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    
    //MARK: - Variables
    let restManager = RestManager()
    let realmManager = RealmManager()
    var searchTextField: SearchTextField!
    var trainStations: [TrainStation] = []
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField = SearchTextField(first: self.fromTextField, second: self.toTextField,
                                                   tableView: self.tableView,
                                                   protocol: self as ProtocolViewController)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapVisualEffectView(_:)))
        self.visualEffectView.addGestureRecognizer(tap)
        
        self.loadData()
    }
    
    func loadData() {
        if let model = self.realmManager.getTrainStations() {
            self.update(trainStations: model)
            self.visualEffectView.isHidden = true
        } else {
            self.visualEffectView.isHidden = false
        }
        self.view.bringSubview(toFront: self.visualEffectView)
        self.downloadDataFromRemote()
    }

    func tapVisualEffectView(_ sender: UITapGestureRecognizer) {
        self.downloadDataFromRemote()
    }
    
    func update(trainStations: [TrainStation]) {
        self.trainStations = trainStations
        self.searchTextField.array = trainStations
    }
    
    func downloadDataFromRemote() {
        self.visualEffectView.isUserInteractionEnabled = false
        self.errorLabel.isHidden = true
        self.activityIndicatorView.startAnimating()
        
        self.restManager.getTrainStations(block: { model in
            DispatchQueue.main.async {
                self.update(trainStations: model)
                self.hideVisualEffectView()
            }
            self.realmManager.updateData(trainStations: model)
        }, error: { (responseCode: Int?) in
            DispatchQueue.main.async {
                if self.trainStations.count == 0 {
                    self.activityIndicatorView.stopAnimating()
                    self.errorLabel.isHidden = false
                    self.visualEffectView.isUserInteractionEnabled = true
                } else if self.realmManager.haveExpiredTrainStations() {
                    self.hideVisualEffectView()
                    self.showAlert(title: NSLocalizedString("AppName", comment: ""),
                                   message:  NSLocalizedString("ExpireMessage", comment: ""),
                                   action: nil)
                }
            }
        })
    }
    
    func hideVisualEffectView() {
        if !self.visualEffectView.isHidden {
            UIView.animate(withDuration: 1.5, animations: {
                self.visualEffectView.isHidden = true
            }, completion: { finished in
                if finished {
                    self.activityIndicatorView.stopAnimating()
                    self.errorLabel.isHidden = true
                }
            })
        }
    }
    
    func showAlert(title: String, message: String, action: ((UIAlertAction?) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: UIAlertActionStyle.default,
                                          handler: action))
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
    
    
    //MARK: - IBOutlet actions
    @IBAction func tapSearchButton() {
        if let firstItem = self.searchTextField.selectedItem[0],
            let secondItem = self.searchTextField.selectedItem[1] {
            self.performSegue(withIdentifier: "TrainViewController",
                              sender: [firstItem, secondItem])
        }
    }
    
    
    //MARK: - Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TrainViewController" {
            let vc = segue.destination as! TrainViewController
            let array = sender as! [TrainStation]
            vc.firstTrainStation = array[0]
            vc.secondTrainStation = array[1]
        }
    }
    
    
    //MARK: - ProtocolViewController methods
    func itemDidChange() {
        if self.searchTextField.selected[0] && self.searchTextField.selected[1] {
            self.searchButton.alpha = 1
            self.searchButton.isEnabled = true
        } else {
            self.searchButton.alpha = 0.4
            self.searchButton.isEnabled = false
        }
    }
}

