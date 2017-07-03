//
//  MainViewController.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit


//MARK: - MainViewControllerDelegate
protocol MainViewControllerDelegate {
    func itemDidChange()
}


//MARK: - MainViewController
class MainViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    
    //MARK: - Variables
    fileprivate let restManager = RestManager.sharedInstance
    fileprivate let realmManager = RealmManager.sharedInstance
    fileprivate var searchTextField: SearchTextField!
    fileprivate var trainStations: [TrainStation] = []
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TrainViewController" {
            let vc = segue.destination as! TrainViewController
            let array = sender as! [TrainStation]
            vc.firstTrainStation = array[0]
            vc.secondTrainStation = array[1]
        }
    }
}


//MARK: - Configuration
extension MainViewController {
    fileprivate func configure() {
        self.searchTextField = SearchTextField(first: self.fromTextField, second: self.toTextField,
                                               tableView: self.tableView,
                                               delegate: self as MainViewControllerDelegate)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapVisualEffectView(_:)))
        self.visualEffectView.addGestureRecognizer(tap)
        
        self.loadData()
    }
    
    private func loadData() {
        if let model = self.realmManager.getTrainStations() {
            self.update(trainStations: model)
            self.visualEffectView.isHidden = true
        } else {
            self.visualEffectView.isHidden = false
        }
        self.view.bringSubview(toFront: self.visualEffectView)
        self.downloadDataFromRemote()
    }
}


//MARK: - Helpers
extension MainViewController {
    fileprivate func update(trainStations: [TrainStation]) {
        self.trainStations = trainStations
        self.searchTextField.array = trainStations
    }
    
    fileprivate func downloadDataFromRemote() {
        self.visualEffectView.isUserInteractionEnabled = false
        self.errorLabel.isHidden = true
        self.activityIndicatorView.startAnimating()
        
        self.restManager.getTrainStations(block: { models in
            DispatchQueue.main.async {
                for model in models {
                    if let trainStation = self.trainStations.first(where: {$0.id == model.id}) {
                        model.recentlySelected = trainStation.recentlySelected
                    }
                }
                self.update(trainStations: models)
                self.hideVisualEffectView()
            }
            self.realmManager.updateData(trainStations: models)
            self.realmManager.deleteTrainStations(all: false)
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
    
    fileprivate func hideVisualEffectView() {
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
    
    fileprivate func showAlert(title: String, message: String, action: ((UIAlertAction?) -> Void)?) {
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
}

//MARK: - User Actions
extension MainViewController {
    @IBAction func tapSearchButton() {
        if let firstItem = self.searchTextField.selectedItem[0],
            let secondItem = self.searchTextField.selectedItem[1] {
            firstItem.recentlySelected = true
            secondItem.recentlySelected = true
            self.realmManager.updateData(trainStations: [firstItem, secondItem])
            
            if firstItem.id == secondItem.id {
                self.showAlert(title: NSLocalizedString("AppName", comment: ""),
                               message: NSLocalizedString("TheSame", comment: ""),
                               action: nil)
            } else {
                self.performSegue(withIdentifier: "TrainViewController",
                                  sender: [firstItem, secondItem])
            }
        }
    }
    
    func tapVisualEffectView(_ sender: UITapGestureRecognizer) {
        self.downloadDataFromRemote()
    }
}


//MARK: - MainViewControllerDelegate
extension MainViewController: MainViewControllerDelegate {
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

