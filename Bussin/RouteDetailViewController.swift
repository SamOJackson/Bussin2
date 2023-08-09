//
//  RouteDetailViewController.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-08-07.
//

import UIKit

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var busStopsTextView: UITextView!

    var selectedRoute: Route!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if a route is selected
        guard let route = selectedRoute else {
            return
        }

        // Set routeName labels
        routeNameLabel.text = route.routeName

        // Create a string to hold the bus stops' information
        var busStopsInfo = ""

        // Loop through each bus stop in the route and append its name and schedule to the text view
        // Loop through each bus stop in the route and append its name and schedule to the text view
                for stop in selectedRoute.stops {
                    busStopsInfo += "Stop Name: \(stop.stopName)\n"

                    // Loop through each schedule item in the stop's schedule
                    for scheduleItem in stop.schedule {
                        let dayOfWeek = scheduleItem.dayOfWeek
                        let times = scheduleItem.times.joined(separator: ", ") // Join the times array into a string
                        busStopsInfo += "Day: \(dayOfWeek), Times: \(times)\n"
                    }

                    // Add a separator between stops
                    busStopsInfo += "----------------------------\n"
                }

        // Set the text view's text to the collected information
        busStopsTextView.text = busStopsInfo
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

