//
//  String+Extension.swift
//  TrainProject
//
//  Created by Karol Majka on 03/07/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import Foundation

extension String {
    func removeAccents() -> String {
        return self
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "ł", with: "l")
    }
}
