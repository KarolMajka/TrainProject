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
import ObjectMapper



//MARK: - DataDownloading
protocol DataDownloading {
    func download<T: Mappable>(type: T.Type, keyPath: String?, url: String, block: @escaping ([T])->(), error: @escaping (Int?) ->())
}

extension DataDownloading {
    func download<T: Mappable>(type: T.Type, keyPath: String?, url: String, block: @escaping ([T])->(), error: @escaping (Int?) ->()) {
        let backgroundQueueForREST = DispatchQueue(label: "com.app.queueForRest", qos: .background, target: nil)
        
        Alamofire.request(url).responseArray(queue: backgroundQueueForREST, keyPath: keyPath, context: nil, completionHandler: { (response: DataResponse<[T]>) in
            switch response.result {
            case .success(let value):
                block(value)
            case .failure(_):
                let responseCode = response.response?.statusCode
                error(responseCode)
            }
        })
    }
}


//MARK: - TrainAPI
protocol TrainAPI: DataDownloading {
    func getTrainStations(block: @escaping ([TrainStation])->(), error: @escaping (Int?) ->())
}

extension TrainAPI {
    public func getTrainStations(block: @escaping ([TrainStation])->(), error: @escaping (Int?) ->()) {
        let url = "https://koleo.pl/api/android/v1/stations.json"
        
        self.download(type: TrainStation.self, keyPath: nil, url: url, block: { model in
            block(model)
        }, error: { errorCode in
            error(errorCode)
        })
    }
}

//MARK: - RestManager Class
class RestManager: TrainAPI {
    
    //MARK: - Shared Instance
    private init() { }
    
    static let sharedInstance : RestManager = {
        let instance = RestManager()
        return instance
    }()
}
