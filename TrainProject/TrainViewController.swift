//
//  TrainViewController.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import UIKit

class TrainViewController: UIViewController {
    
    //MARK: - Variables
    var firstTrainStation: TrainStation!
    var secondTrainStation: TrainStation!
    
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //MARK: - IBOutlet actions
    @IBAction func tapBackButton() {
        self.navigationController!.popViewController(animated: true)
    }
}
