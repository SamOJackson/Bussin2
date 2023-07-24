//
//  FirebaseManager.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-24.
//

import Firebase

class FirebaseManager {

    // ...

    // Create a new bus stop in Firebase Firestore
    static func createBusStop(busStop: BusStop, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("BusStops").document(busStop.stopId)

        let data: [String: Any] = [
            "stopId": busStop.stopId,
            "stopName": busStop.stopName,
            "latitude": busStop.latitude,
            "longitude": busStop.longitude
        ]

        documentRef.setData(data) { error in
            completion(error)
        }
    }

    // Read bus stops from Firebase Firestore
    static func fetchBusStops(completion: @escaping ([BusStop]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("BusStops").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            var busStops: [BusStop] = []
            for document in querySnapshot!.documents {
                let busStopData = document.data()
                let stopId = document.documentID
                let stopName = busStopData["stopName"] as? String ?? ""
                let latitude = busStopData["latitude"] as? Double ?? 0.0
                let longitude = busStopData["longitude"] as? Double ?? 0.0
                let busStop = BusStop(stopId: stopId, stopName: stopName, latitude: latitude, longitude: longitude)
                busStops.append(busStop)
            }

            completion(busStops, nil)
        }
    }

    // Update a bus stop in Firebase Firestore
    static func updateBusStop(busStop: BusStop, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("BusStops").document(busStop.stopId)

        let data: [String: Any] = [
            "stopId": busStop.stopId,
            "stopName": busStop.stopName,
            "latitude": busStop.latitude,
            "longitude": busStop.longitude
        ]

        documentRef.setData(data) { error in
            completion(error)
        }
    }

    // Delete a bus stop from Firebase Firestore
    static func deleteBusStop(stopId: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("BusStops").document(stopId)

        documentRef.delete { error in
            completion(error)
        }
    }
}
