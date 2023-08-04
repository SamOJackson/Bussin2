// FirebaseManager.swift
// Bussin
//
// Created by Diem Nguyen on 2023-07-24.
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
            "longitude": busStop.longitude,
            "schedule": busStop.schedule.map { scheduleItem -> [String: Any] in
                return [
                    "dayOfWeek": scheduleItem.dayOfWeek,
                    "times": scheduleItem.times.joined(separator: ", ") // Convert the array of times to a comma-separated string
                ]
            }
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

                // Parse the schedule data
                let scheduleData = busStopData["schedule"] as? [[String: Any]] ?? []
                var schedule: [ScheduleItem] = []
                for itemData in scheduleData {
                    if let dayOfWeek = itemData["dayOfWeek"] as? String,
                       let timesString = itemData["times"] as? String {
                        let times = timesString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                        let scheduleItem = ScheduleItem(dayOfWeek: dayOfWeek, times: times)
                        schedule.append(scheduleItem)
                    }
                }

                let busStop = BusStop(stopId: stopId, stopName: stopName, latitude: latitude, longitude: longitude, schedule: schedule)
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
            "longitude": busStop.longitude,
            "schedule": busStop.schedule.map { scheduleItem -> [String: Any] in
                return [
                    "dayOfWeek": scheduleItem.dayOfWeek,
                    "times": scheduleItem.times.joined(separator: ", ") // Convert the array of times to a comma-separated string
                ]
            }
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
        // Fetch bus stops based on stopIds asynchronously and call the completion handler when done.
        var fetchedBusStops: [BusStop] = []

        let dispatchGroup = DispatchGroup()

        for stopId in stopIds {
            dispatchGroup.enter()

            // Fetch a single bus stop by stopId from Firestore
            db.collection("BusStops").document(stopId).getDocument { document, error in
                if let document = document, document.exists {
                    let busStopData = document.data() ?? [:]
                    let stopName = busStopData["stopName"] as? String ?? ""
                    let latitude = busStopData["latitude"] as? Double ?? 0.0
                    let longitude = busStopData["longitude"] as? Double ?? 0.0

                    // Parse the schedule data
                    let scheduleData = busStopData["schedule"] as? [[String: Any]] ?? []
                    var schedule: [ScheduleItem] = []
                    for itemData in scheduleData {
                        if let dayOfWeek = itemData["dayOfWeek"] as? String,
                           let timesString = itemData["times"] as? String {
                            let times = timesString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                            let scheduleItem = ScheduleItem(dayOfWeek: dayOfWeek, times: times)
                            schedule.append(scheduleItem)
                        }
                    }

                    // Create a BusStop object with schedule
                    let busStop = BusStop(stopId: stopId, stopName: stopName, latitude: latitude, longitude: longitude, schedule: schedule)
                    fetchedBusStops.append(busStop)
                }

                dispatchGroup.leave()
            }
        }

        // Notify the completion handler when all bus stops are fetched
        dispatchGroup.notify(queue: .main) {
            completion(fetchedBusStops)
        }
    }

    // Function to create a new bus route in Firestore
    func createBusRoute(routeId: String, routeName: String, stopIds: [String], completion: @escaping (Error?) -> Void) {
        // Fetch the corresponding BusStop objects for the given stopIds
        fetchBusStopsForIds(stopIds) { busStopsForRoute in
            var routeData: [String: Any] = [
                "routeId": routeId,
                "routeName": routeName
            ]

            // Convert the BusStop objects to dictionaries
            let stopDictionaries = busStopsForRoute.map { $0.toDictionary() }

            // Add the BusStop dictionaries to the routeData
            routeData["stops"] = stopDictionaries

            // Assuming you have a "busRoutes" collection in your Firestore database
            self.db.collection(self.busRoutesCollection).document(routeId).setData(routeData) { error in
                completion(error)
            }
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
        // Fetch the corresponding BusStop objects for the given stopIds
        fetchBusStopsForIds(stopIds) { busStopsForRoute in
            var routeData: [String: Any] = [
                "routeId": routeId,
                "routeName": routeName
            ]

            // Convert the BusStop objects to dictionaries
            let stopDictionaries = busStopsForRoute.map { $0.toDictionary() }

            // Add the BusStop dictionaries to the routeData
            routeData["stops"] = stopDictionaries

            // Assuming you have a "busRoutes" collection in your Firestore database
            self.db.collection(self.busRoutesCollection).document(routeId).setData(routeData) { error in
                completion(error)
            }
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
