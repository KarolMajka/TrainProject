//
//  Array+Extension.swift
//  TrainProject
//
//  Created by Karol Majka on 03/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import Foundation

extension Array {
    public subscript (safe index: Index) -> Element? {
        return index.distance(to: endIndex) > 0 ? self[index] : nil
    }
}
