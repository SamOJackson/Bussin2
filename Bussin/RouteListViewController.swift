//
//  RouteListViewController.swift
//  Bussin
//
//  Created by Wayne Nguyen on 2023-08-07.
//


import UIKit

class RouteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var busRoutes: [Route] = []

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
                self.busRoutes = busRoutes
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table View Delegate and Data Source

extension RouteListViewController: UITableViewDelegate, UITableViewDataSource {

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

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRoute = busRoutes[indexPath.row]
            
            FirebaseManager.shared.fetchBusRoute(byId: selectedRoute.routeId) { [weak self] route, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching bus route: \(error)")
                    // Handle error if needed
                } else if let route = route {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showRouteDetail", sender: route)
                    }
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRouteDetail",
           let destinationVC = segue.destination as? RouteDetailViewController,
           let selectedRoute = sender as? Route {
            print("Selected Route in prepare: \(selectedRoute.routeName)")
            // Print the contents of the selectedRoute object
                    dump(selectedRoute)
            destinationVC.selectedRoute = selectedRoute
        }
    }
}
