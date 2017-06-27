//
//  TrainViewController.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit
import MapKit

class TrainViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
  
    
    //MARK: - Variables
    var firstTrainStation: TrainStation!
    var secondTrainStation: TrainStation!
    fileprivate var firstPin: Pin!
    fileprivate var secondPin: Pin!
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMap()
    }
    
    
    //MARK: - MKMapView methods
    func setMap() {
        self.firstPin = createPin(title: self.firstTrainStation.name, latitude: self.firstTrainStation.latitude, longitude: self.firstTrainStation.longitude)
        self.secondPin = createPin(title: self.secondTrainStation.name, latitude: self.secondTrainStation.latitude, longitude: self.secondTrainStation.longitude)
        
        self.mapView.addAnnotation(firstPin)
        self.mapView.addAnnotation(secondPin)
        self.mapView.showAnnotations([firstPin, secondPin], animated: true)
        
        self.calculateDistance()
    }
    
    fileprivate func createPin(title: String, latitude: CGFloat, longitude: CGFloat) -> Pin {
        return Pin(title: title,
                           coordinate: CLLocationCoordinate2D(latitude: Double(latitude),
                                                              longitude: Double(longitude)))
    }
    
    func calculateDistance() {
        let firstLocation = CLLocation(latitude: self.firstPin.coordinate.latitude, longitude: self.firstPin.coordinate.longitude)
        let secondLocation = CLLocation(latitude: self.secondPin.coordinate.latitude, longitude: self.secondPin.coordinate.longitude)
        let kilometers = firstLocation.distance(from: secondLocation) / 1000
        self.countLabel.text = String(format:"%.0f", kilometers.rounded()) + " km"
    }
    
    //MARK: - IBOutlet actions
    @IBAction func tapBackButton() {
        self.navigationController!.popViewController(animated: true)
    }
}

//MARK:- Annotations Class
fileprivate class Pin: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}
