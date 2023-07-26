//
//  FirebaseManager.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-24.
//

import Firebase

class FirebaseManager {

    // CRUD FOR BUS STOPS

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
    
    //  CRUD FOR ROUTES
    // Singleton instance for BusRouteController
    static let shared = FirebaseManager()

    // Firestore database reference
    let db = Firestore.firestore()

    // Collection name for bus routes in Firestore
    let busRoutesCollection = "busRoutes"
    
    // Function to fetch the BusStop objects corresponding to given stopIds
        func fetchBusStopsForIds(_ stopIds: [String], completion: @escaping ([BusStop]) -> Void) {
            // Implement the logic to fetch BusStop objects for the given stopIds
            // For example, you can query your Firestore collection for the BusStop objects with matching stopIds.
            // Assuming you have a function that fetches bus stops for given stopIds asynchronously.

            // Fetch bus stops based on stopIds asynchronously and call the completion handler when done.
            // Sample code (replace this with your actual implementation):
            let fetchedBusStops: [BusStop] = [] // Replace this with the actual fetched bus stops
            completion(fetchedBusStops)
        }

    // Function to create a new bus route in Firestore
        func createBusRoute(routeId: String, routeName: String, stopIds: [String], completion: @escaping (Error?) -> Void) {
            let routeData: [String: Any] = [
                "routeId": routeId,
                "routeName": routeName,
                "stopIds": stopIds
            ]

            // Assuming you have a "busRoutes" collection in your Firestore database
            db.collection(busRoutesCollection).document(routeId).setData(routeData) { error in
                completion(error)
            }
        }

    // Function to fetch all bus routes from Firestore
        func fetchBusRoutes(completion: @escaping ([Route], Error?) -> Void) {
            var busRoutes: [Route] = []

            // Assuming you have a "busRoutes" collection in your Firestore database
            db.collection(busRoutesCollection).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching bus routes: \(error)")
                    completion(busRoutes, error)
                    return
                }

                for document in querySnapshot!.documents {
                                let data = document.data()

                                if let routeId = data["routeId"] as? String,
                                   let routeName = data["routeName"] as? String {
                                    // Parse the stops array from Firestore data
                                    let stops = Route.parseStopsFromFirestore(data)

                                    let route = Route(routeId: routeId, routeName: routeName, stops: stops)
                                    busRoutes.append(route)
                                }
                            }

                completion(busRoutes, nil)
            }
        }


    // Function to update an existing bus route in Firestore
        func updateBusRoute(routeId: String, routeName: String, stopIds: [String], completion: @escaping (Error?) -> Void) {
            let routeData: [String: Any] = [
                "routeId": routeId,
                "routeName": routeName,
                "stopIds": stopIds
            ]

            // Assuming you have a "busRoutes" collection in your Firestore database
            db.collection(busRoutesCollection).document(routeId).setData(routeData) { error in
                completion(error)
            }
        }

        // Function to delete an existing bus route from Firestore
        func deleteBusRoute(routeId: String, completion: @escaping (Error?) -> Void) {
            // Assuming you have a "busRoutes" collection in your Firestore database
            db.collection(busRoutesCollection).document(routeId).delete { error in
                completion(error)
            }
        }
}
