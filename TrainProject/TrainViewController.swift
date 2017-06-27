//
//  TrainViewController.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {

    var firstTrainStation: TrainStation!
    var secondTrainStation: TrainStation!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapBackButton() {
        self.navigationController!.popViewController(animated: true)
    }
}
