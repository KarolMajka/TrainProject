//
//  Extensions.swift
//  TrainProject
//
//  Created by Karol Majka on 28/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import Foundation


extension Array {
    public subscript (safe index: Index) -> Element? {
        return index.distance(to: endIndex) > 0 ? self[index] : nil
    }
}

extension String {
    func removeAccents() -> String {
        return self
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "ł", with: "l")
    }
}
