//
//  MapsViewController.swift
//  Bussin
//
//  Created by Wayne Nguyen on 2023-07-20.
//

import UIKit
import MapKit
import FirebaseFirestore

class MapsViewController: UIViewController {
//
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var MKMapView: MKMapView!
    var busStops: [BusStop] = []
    var tapCount = 0
    var isWaitingForTripleTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default region to Barrie, Ontario
        let barrieLocation = CLLocationCoordinate2D(latitude: 44.3894, longitude: -79.6903)
        let region = MKCoordinateRegion(center: barrieLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
        MKMapView.setRegion(region, animated: true)
        
        // Set up the tap gesture recognizer for the routesButton
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(routesButtonTapped))
            tapGesture.numberOfTapsRequired = 3
            mapButton.addGestureRecognizer(tapGesture)
        routeButton.addGestureRecognizer(tapGesture)
        
        // Set the MKMapView delegate
        MKMapView.delegate = self
        
        // Add the bus stops as pins on the map
        fetchAndAddBusStopsFromFirebase()
        addBusStopsToMap()
        
        // Fetch and display the bus route on the map
        fetchAndDisplayBusRoute()
    }
    // Function to fetch bus stop data from Firebase and add them as annotations to the map
        func fetchAndAddBusStopsFromFirebase() {
            FirebaseManager.fetchBusStops { [weak self] busStops, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching bus stops: \(error.localizedDescription)")
                } else {
                    self.busStops = busStops ?? []

                    // Add the bus stops as pins on the map
                    self.addBusStopsToMap()
                }
            }
        }

    func addBusStopsToMap() {
        for busStop in busStops {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: busStop.latitude, longitude: busStop.longitude)
            annotation.title = busStop.stopName
            MKMapView.addAnnotation(annotation)

            // Make the annotation view user-interactable
            if let annotationView = MKMapView.view(for: annotation) {
                annotationView.isUserInteractionEnabled = true
            }
        }
    }

    var adminPage: String = ""

    @objc func routesButtonTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
                adminPage = "routes"
                tapCount += 1

                // Check if the admin button is tapped three times
                if tapCount == 3 {
                    openAdminInterface()
                    // Reset the tap count to 0
                    tapCount = 0
                } else if tapCount == 1 {
                    performSegue(withIdentifier: "showRouteList", sender: self)
                }
            }
    }

    @objc func mapButtonTapped(_ sender: UIButton) {
        adminPage = "stops"
        tapCount += 1

        // Check if the admin button is tapped three times
        if tapCount == 3 {
            openAdminInterface()
            // Reset the tap count to 0
            tapCount = 0
        }
    }

    // Function to open the AdminViewController
    func openAdminInterface() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if adminPage == "stops" {
            if let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminStopsViewController") as? AdminStopsViewController {
                self.present(adminVC, animated: true, completion: nil)
            }
        } else if adminPage == "routes" {
            if let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminRoutesViewController") as? AdminRoutesViewController {
                self.present(adminVC, animated: true, completion: nil)
            }
        }
    }

    
    // Function to fetch and display the complete bus route on the map
    func fetchAndDisplayBusRoute() {
        FirebaseManager.shared.fetchBusRoutes { [weak self] busRoutes, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching bus routes: \(error.localizedDescription)")
                return
            }

            // Assuming you want to display the first bus route for now
            if let firstBusRoute = busRoutes.first, firstBusRoute.stops.count >= 2 {
                let stops = firstBusRoute.stops
                let stopCoordinates = stops.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }

                // Use the MapKit Directions API to obtain the route between each pair of consecutive bus stops
                self.calculateRoutesBetweenStops(coordinates: stopCoordinates) { routes, error in
                    if let error = error {
                        print("Error calculating routes: \(error.localizedDescription)")
                    } else if let routes = routes {
                        // Draw each segment of the bus route on the map
                        for route in routes {
                            self.drawBusRoute(route)
                        }
                    }
                }
            }
        }
    }


    // Function to calculate the route between each pair of consecutive bus stops using MapKit Directions API
    func calculateRoutesBetweenStops(coordinates: [CLLocationCoordinate2D], completion: @escaping ([MKRoute]?, Error?) -> Void) {
        var routes: [MKRoute] = []
        let dispatchGroup = DispatchGroup()

        for i in 0 ..< coordinates.count - 1 {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[i]))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[i + 1]))
            request.transportType = .automobile // You can use .walking for walking directions
            request.requestsAlternateRoutes = false

            let directions = MKDirections(request: request)
            dispatchGroup.enter()

            directions.calculate { response, error in
                if let error = error {
                    completion(nil, error)
                } else if let route = response?.routes.first {
                    routes.append(route)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(routes, nil)
        }
    }

        // Function to draw the bus route on the map
        func drawBusRoute(_ route: MKRoute) {
            MKMapView.addOverlay(route.polyline)
        }
    // Function to handle the tap on a pin/bus stop
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let selectedAnnotation = view.annotation as? MKPointAnnotation else {
                return
            }
            
            // Find the corresponding bus stop from the selectedAnnotation's title
            if let selectedBusStop = busStops.first(where: { $0.stopName == selectedAnnotation.title }) {
                performSegue(withIdentifier: "showBusStopDetails", sender: selectedBusStop)
            }
            
            // Deselect the pin so that it can be selected again
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
    
    // Prepare for the segue in MapsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusStopDetails",
           let destinationVC = segue.destination as? BusStopDetailsViewController,
           let selectedBusStop = sender as? BusStop {
            print("Selected Bus Stop: \(selectedBusStop.stopName)")
            destinationVC.selectedBusStop = selectedBusStop
        }
    }



}

// MARK: - MKMapViewDelegate

extension MapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
