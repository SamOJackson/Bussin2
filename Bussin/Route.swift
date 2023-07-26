//
//  Route.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-24.
//

import Foundation

struct Route {
    let routeId: String
    let routeName: String
    let stops: [BusStop] // Array of bus stop IDs
    
    // Function to parse the stops array from Firestore data
        static func parseStopsFromFirestore(_ data: [String: Any]) -> [BusStop] {
            guard let stopsData = data["stops"] as? [[String: Any]] else {
                return []
            }

            var stops: [BusStop] = []
            for stopData in stopsData {
                if let stopId = stopData["stopId"] as? String,
                   let stopName = stopData["stopName"] as? String,
                   let latitude = stopData["latitude"] as? Double,
                   let longitude = stopData["longitude"] as? Double {
                    let stop = BusStop(stopId: stopId, stopName: stopName, latitude: latitude, longitude: longitude)
                    stops.append(stop)
                }
            }
            return stops
        }
}
