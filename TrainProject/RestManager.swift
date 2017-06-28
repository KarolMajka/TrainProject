//
//  RestManager.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class RestManager {
    
    public func getTrainStations(block: @escaping ([TrainStation])->(), error: @escaping (Int?) ->()) {
        let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest",qos: .background, target: nil)
        let url = "https://koleo.pl/api/android/v1/stations.json"
        
        Alamofire.request(url).responseArray(queue: backgroundQueueForREST, keyPath: nil, context: nil, completionHandler: { (response: DataResponse<[TrainStation]>) in
            
            let responseCode = response.response?.statusCode
            if responseCode == 200, let model = response.result.value {
                block(model)
            } else {
                error(responseCode)
            }
        })
    }
    
}
