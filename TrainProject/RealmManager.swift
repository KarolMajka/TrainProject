//
//  RealmManager.swift
//  TrainProject
//
//  Created by Karol Majka on 26/06/2017.
//  Copyright © 2017 Karol Majka. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {

    func updateData(trainStations model: [TrainStation]) {
        var realmTrainStations: [RealmTrainStation] = []
        for trainStation in model {
            realmTrainStations.append(self.create(realmTrainStation: trainStation))
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(realmTrainStations, update: true)
            realm.delete(realm.objects(RealmTrainStation.self).filter("expiry <= %@", Date()))
        }
    }
    
    func deleteTrainStations() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(RealmTrainStation.self))
        }
    }
    
    
    func haveExpiredTrainStations() -> Bool {
        let realm = try! Realm()
        if realm.objects(RealmTrainStation.self)
            .filter("expiry <= %@", Date())
            .count != 0 {
            return false
        } else {
            return true
        }
    }
    
    func getTrainStations() -> [TrainStation]? {
        let realm = try! Realm()
        let objects = realm.objects(RealmTrainStation.self)
        
        if objects.count == 0 || realm.objects(RealmTrainStation.self).filter("expiry >= %@", Date()).count == 0 {
            return nil
        }
        var array: [TrainStation] = []
        for object in objects {
            array.append(TrainStation(id: object.id,
                                      latitude: object.latitude,
                                      longitude: object.longitude,
                                      name: object.name))
        }
        return array
    }
    
    private func create(realmTrainStation model: TrainStation) -> RealmTrainStation  {
        let realmTrainStation = RealmTrainStation()
        realmTrainStation.id = model.id
        realmTrainStation.latitude = model.latitude
        realmTrainStation.longitude = model.longitude
        realmTrainStation.name = model.name
        realmTrainStation.expiry = Date().addingTimeInterval(24*60*60)
        return realmTrainStation
    }
    
}


//MARK: - Realm Objects
class RealmTrainStation: Object {
    
    dynamic var id: Int = -1
    dynamic var latitude: CGFloat = 0
    dynamic var longitude: CGFloat = 0
    dynamic var name: String = ""
    dynamic var expiry: Date = Date()
    
    override class func primaryKey() -> String {
        return "id"
    }
}
