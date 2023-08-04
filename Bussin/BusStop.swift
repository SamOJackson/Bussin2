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
    var schedule: [ScheduleItem]
    
    // Function to convert the BusStop object to a dictionary - for JSON serialization
        func toDictionary() -> [String: Any] {
            var scheduleArray: [[String: Any]] = []
            for scheduleItem in schedule {
                let scheduleDict: [String: Any] = [
                    "dayOfWeek": scheduleItem.dayOfWeek,
                    "times": scheduleItem.times
                ]
                scheduleArray.append(scheduleDict)
            }

            return [
                "stopId": stopId,
                "stopName": stopName,
                "latitude": latitude,
                "longitude": longitude,
                "schedule": scheduleArray
            ]
        }
}


struct ScheduleItem {
    let dayOfWeek: String // E.g., "Monday", "Tuesday", etc.
    let times: [String] // E.g., "09:00 AM"
}
