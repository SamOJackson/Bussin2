//
//  MapsViewController.swift
//  Bussin
//
//  Created by Diem Nguyen on 2023-07-20.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {
//
    @IBOutlet weak var mapButton: UIButton!
    var tapCount = 0
    @IBOutlet weak var MKMapView: MKMapView!
    var busStops: [BusStop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default region to Barrie, Ontario
        let barrieLocation = CLLocationCoordinate2D(latitude: 44.3894, longitude: -79.6903)
        let region = MKCoordinateRegion(center: barrieLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
        MKMapView.setRegion(region, animated: true)
        
        // Set up the tap gesture recognizer for the admin button
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapButtonTapped))
        tapGesture.numberOfTapsRequired = 3
        mapButton.addGestureRecognizer(tapGesture)
        
        // Add the bus stops as pins on the map
        addBusStopsToMap()
        
        // Fetch and display the bus route on the map
        fetchAndDisplayBusRoute()
    }
    func addBusStopsToMap() {
            for busStop in busStops {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: busStop.latitude, longitude: busStop.longitude)
                annotation.title = busStop.stopName
                MKMapView.addAnnotation(annotation)
            }
        }
    
    var adminPage: String = ""

    @objc func routesButtonTapped(_ sender: UIButton) {
        adminPage = "routes"
        tapCount += 1

        // Check if the admin button is tapped three times
        if tapCount == 3 {
            openAdminInterface()
            // Reset the tap count to 0
            tapCount = 0
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

    
    func fetchAndDisplayBusRoute() {
            FirebaseManager.shared.fetchBusRoutes { [weak self] busRoutes, error in
                guard let self = self else { return }

                // Assuming you want to display the first bus route for now
                if let firstBusRoute = busRoutes.first {
                    let stops = firstBusRoute.stops

                    // Extract the stopIds from the stops array
                    let stopIds = stops.map { $0.stopId }

                    // Fetch the corresponding BusStop objects based on the stopIds
                    FirebaseManager.shared.fetchBusStopsForIds(stopIds) { busStopsForRoute in

                        // Draw the bus route on the map using the fetched bus stops
                        self.drawBusRoute(busStopsForRoute)
                    }
                }
            }
        }
    
    func drawBusRoute(_ busStops: [BusStop]) {
            let busRouteCoordinates = busStops.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            let busRoutePolyline = MKPolyline(coordinates: busRouteCoordinates, count: busRouteCoordinates.count)
            MKMapView.addOverlay(busRoutePolyline)
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
