//
//  BusStopDetailsViewController.swift
//  Bussin
//
//  Created by Wayne Nguyen on 2023-08-04.
//

import UIKit

class BusStopDetailsViewController: UIViewController {
    
    // Outlets for your UI elements (e.g., labels, table view)
    @IBOutlet weak var stopNameLabel: UILabel!
    @IBOutlet weak var daysOfWeekLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    
    var selectedBusStop: BusStop? // Variable to hold the selected bus stop data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display the details of the selected bus stop
        if let busStop = selectedBusStop {
            stopNameLabel.text = busStop.stopName
            
            // Prepare strings for schedule and daysOfWeek labels
            let scheduleString = busStop.schedule.map { "\($0.dayOfWeek): " + $0.times.joined(separator: ", ") }.joined(separator: "\n")
            let daysOfWeekString = busStop.schedule.map { $0.dayOfWeek }.joined(separator: ", ")
            
            // Update the labels with the prepared strings
            scheduleLabel.text = scheduleString
            daysOfWeekLabel.text = daysOfWeekString
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
