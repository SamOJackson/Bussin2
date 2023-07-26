//
//  AdminRoutesViewController.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-25.
//

import UIKit

class AdminRoutesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var routeIdTextField: UITextField!
    @IBOutlet weak var routeNameTextField: UITextField!
    @IBOutlet weak var busStopIdsTextField: UITextField!

    var busRoutes: [Route] = []
    var selectedRowIndex: Int? // To keep track of the selected row index in the table view

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        // Fetch bus routes and display them in the table view
        fetchBusRoutes()
    }

    // Fetch bus routes from Firebase and display them in the table view
        func fetchBusRoutes() {
            FirebaseManager.shared.fetchBusRoutes { [weak self] busRoutes, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching bus routes: \(error.localizedDescription)")
                } else {
                    // Create a temporary array to store updated routes
                    var updatedRoutes: [Route] = []

                    // Fetch the corresponding BusStop objects for each route's stopIds
                    let dispatchGroup = DispatchGroup()
                    for var route in busRoutes {
                        dispatchGroup.enter()
                        FirebaseManager.shared.fetchBusStopsForIds(route.stops.map { $0.stopId }) { busStopsForRoute in
                            // Update the stops array of the route with the fetched BusStop objects
                            route.stops = busStopsForRoute // Now this is allowed since 'route' is a variable
                            updatedRoutes.append(route)
                            dispatchGroup.leave()
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        // All BusStop objects have been fetched and associated with the routes.
                        self.busRoutes = updatedRoutes
                        self.tableView.reloadData()
                    }
                }
            }
        }


    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let routeId = routeIdTextField.text, !routeId.isEmpty,
              let routeName = routeNameTextField.text, !routeName.isEmpty,
              let stopIdsString = busStopIdsTextField.text, !stopIdsString.isEmpty else {
            return
        }

        // Convert the comma-separated stopIdsString to an array of stopIds
        let stopIds = stopIdsString.components(separatedBy: ",")

        // Fetch the corresponding BusStop objects for the given stopIds
        FirebaseManager.shared.fetchBusStopsForIds(stopIds) { busStopsForRoute in
            // Create a new route with the fetched BusStop objects
            let newRoute = Route(routeId: routeId, routeName: routeName, stops: busStopsForRoute)

            // Save the new route to Firebase
            FirebaseManager.shared.createBusRoute(routeId: routeId, routeName: routeName, stopIds: stopIds) { error in
                if let error = error {
                    print("Error creating bus route: \(error.localizedDescription)")
                } else {
                    print("Bus route created successfully!")
                    // Append the new route to the local busRoutes array and reload the table view
                    self.busRoutes.append(newRoute)
                    self.tableView.reloadData()

                    // Clear the text fields after saving
                    self.clearTextFields()
                }
            }
        }
    }


    // Function to clear the text fields
    func clearTextFields() {
        routeIdTextField.text = ""
        routeNameTextField.text = ""
        busStopIdsTextField.text = ""
        selectedRowIndex = nil
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Delegate and Data Source

extension AdminRoutesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busRoutes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as? RouteTableViewCell else {
            return UITableViewCell()
        }

        let route = busRoutes[indexPath.row]
        cell.routeIdLabel.text = route.routeId
        cell.routeNameLabel.text = route.routeName
        cell.routeStopIdsLabel.text = route.stops.map { $0.stopId }.joined(separator: ", ")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoute = busRoutes[indexPath.row]
        routeIdTextField.text = selectedRoute.routeId
        routeNameTextField.text = selectedRoute.routeName
        busStopIdsTextField.text = selectedRoute.stops.map { $0.stopId }.joined(separator: ", ")

        // Store the selected index to perform an update on saveButtonTapped
        selectedRowIndex = indexPath.row
    }
    
    // Function to calculate cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let route = busRoutes[indexPath.row]
        
        // Calculate the required height for the cell based on its content.
        let routeIdHeight = route.routeId.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).height
        let routeNameHeight = route.routeName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).height
        let stopIdsHeight = route.stops.map { $0.stopId }.joined(separator: ", ").size(withAttributes: [.font: UIFont.systemFont(ofSize: 17)]).height
        
        // Add extra padding or adjust as needed.
        let cellPadding: CGFloat = 20
        
        // Total height of the cell.
        let totalHeight = routeIdHeight + routeNameHeight + stopIdsHeight + cellPadding
        
        // Return the calculated height.
        return totalHeight
    }

}
