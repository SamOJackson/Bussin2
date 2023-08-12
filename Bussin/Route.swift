// Route.swift
// Bussin
//
// Created by Wayne Nguyen on 2023-07-24.
//

import Foundation

struct Route {
    var routeId: String
    var routeName: String
    var stops: [BusStop] // Array of bus stops in the route
    
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
               let longitude = stopData["longitude"] as? Double,
               let scheduleData = stopData["schedule"] as? [[String: Any]] {
                
                var schedule: [ScheduleItem] = []
                for itemData in scheduleData {
                    if let dayOfWeek = itemData["dayOfWeek"] as? String,
                       let timesString = itemData["times"] as? String {
                        let times = timesString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                        let scheduleItem = ScheduleItem(dayOfWeek: dayOfWeek, times: times)
                        schedule.append(scheduleItem)
                    }
                }
                
                let stop = BusStop(stopId: stopId, stopName: stopName, latitude: latitude, longitude: longitude, schedule: schedule)
                stops.append(stop)
            }
        }
        return stops
    }
}
