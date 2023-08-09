//  AdminStopsViewController.swift
//  Bussin
//
//  Created by Wayne Nguyen on 2023-07-24.
//

import UIKit

class AdminStopsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopIdTextField: UITextField!
    
    @IBOutlet weak var stopNameTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    @IBOutlet weak var dayOfWeekTextField: UITextField!
    @IBOutlet weak var timesTextField: UITextField!
    
    var busStops: [BusStop] = []
    var selectedRowIndex: Int? // To keep track of the selected row index in the table view
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        // Fetch bus stops and display them in the table view
        fetchBusStops()
    }

    // Fetch bus stops from Firebase and reload the table view
    func fetchBusStops() {
        FirebaseManager.fetchBusStops { (busStops, error) in
            if let error = error {
                print("Error fetching bus stops: \(error.localizedDescription)")
            } else {
                self.busStops = busStops ?? []
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Fetch the schedule details from the text fields
        guard let stopId = stopIdTextField.text, !stopId.isEmpty,
              let stopName = stopNameTextField.text, !stopName.isEmpty,
              let latitudeStr = latitudeTextField.text, let latitude = Double(latitudeStr),
              let longitudeStr = longitudeTextField.text, let longitude = Double(longitudeStr),
              let dayOfWeek = dayOfWeekTextField.text, !dayOfWeek.isEmpty,
              let timesString = timesTextField.text, !timesString.isEmpty else {
            return
        }

        // Convert the comma-separated times string to an array of strings
        let times = timesString.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        if let selectedIndex = selectedRowIndex {
            // Update or delete existing bus stop
            if selectedIndex >= 0 && selectedIndex < busStops.count {
                var busStopToUpdate = busStops[selectedIndex]
                busStopToUpdate.stopName = stopName
                busStopToUpdate.latitude = latitude
                busStopToUpdate.longitude = longitude
                busStopToUpdate.schedule = [ScheduleItem(dayOfWeek: dayOfWeek, times: times)]

                // Perform update operation
                FirebaseManager.updateBusStop(busStop: busStopToUpdate) { error in
                    if let error = error {
                        print("Error updating bus stop: \(error.localizedDescription)")
                    } else {
                        print("Bus stop updated successfully!")
                        self.fetchBusStops() // Refresh the table view
                    }
                }
            }
        } else {
            // Create new bus stop
            let scheduleItem = ScheduleItem(dayOfWeek: dayOfWeek, times: times)
            let newBusStop = BusStop(stopId: stopId, stopName: stopName, latitude: latitude, longitude: longitude, schedule: [scheduleItem])
            FirebaseManager.createBusStop(busStop: newBusStop) { error in
                if let error = error {
                    print("Error creating bus stop: \(error.localizedDescription)")
                } else {
                    print("Bus stop created successfully!")
                    self.fetchBusStops() // Refresh the table view
                }
            }
        }

        // Clear the text fields after saving
        clearTextFields()
    }
    
    // Function to delete an existing bus stop
    func deleteExistingBusStop(at index: Int) {
        if index >= 0 && index < busStops.count {
            let busStopToDelete = busStops[index]
            // Perform delete operation
            FirebaseManager.deleteBusStop(stopId: busStopToDelete.stopId) { error in
                if let error = error {
                    print("Error deleting bus stop: \(error.localizedDescription)")
                } else {
                    print("Bus stop deleted successfully!")
                    self.fetchBusStops() // Refresh the table view
                }
            }
        }
    }
    
    // Function to clear the text fields
    func clearTextFields() {
        stopIdTextField.text = ""
        stopNameTextField.text = ""
        latitudeTextField.text = ""
        longitudeTextField.text = ""
        dayOfWeekTextField.text = ""
        timesTextField.text = ""
        selectedRowIndex = nil
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table View Delegate and Data Source

extension AdminStopsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopCell", for: indexPath) as? BusStopTableViewCell else {
            return UITableViewCell()
        }

        let busStop = busStops[indexPath.row]
        cell.cellIdTextLabel.text = busStop.stopId
        cell.cellNameTextLabel.text = busStop.stopName
        cell.cellLatitudeLabel.text = String(busStop.latitude)
        cell.cellLongitudeLabel.text = String(busStop.longitude)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBusStop = busStops[indexPath.row]
        stopIdTextField.text = selectedBusStop.stopId
        stopNameTextField.text = selectedBusStop.stopName
        latitudeTextField.text = String(selectedBusStop.latitude)
        longitudeTextField.text = String(selectedBusStop.longitude)

        // Store the selected index to perform an update on saveButtonTapped
        selectedRowIndex = indexPath.row
    }

    // Swipe to delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteExistingBusStop(at: indexPath.row)
        }
    }
}
