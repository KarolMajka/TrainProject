//
//  TrainStation.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import Foundation
import ObjectMapper


class TrainStation: NSObject, Mappable {
    
    var id: Int = 0
    var latitude: CGFloat = 0
    var longitude: CGFloat = 0
    var name: String = ""
    
    required init?(map: Map) {
        if map.JSON["id"] == nil || map.JSON["latitude"] as? CGFloat == 0 ||
            map.JSON["longitude"] as? CGFloat == 0 || map.JSON["name"] == nil ||
            map.JSON["latitude"] as? CGFloat == nil || map.JSON["longitude"] as? CGFloat == nil  {
            return nil
        }
    }

    init(id: Int, latitude: CGFloat, longitude: CGFloat, name: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        name <- map["name"]
    }
}
