//
//  BusStop.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-24.
//

import Foundation

// Bus stop model
struct BusStop {
    var stopId: String
    var stopName: String
    var latitude: Double
    var longitude: Double
    
    // Function to convert the BusStop object to a dictionary
        func toDictionary() -> [String: Any] {
            return [
                "stopId": stopId,
                "stopName": stopName,
                "latitude": latitude,
                "longitude": longitude
            ]
        }
}
