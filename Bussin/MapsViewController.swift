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
    }
    

    @objc func mapButtonTapped(_ sender: UIButton) {
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
            if let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminStopsViewController") as? AdminStopsViewController {
                self.present(adminVC, animated: true, completion: nil)
            }
        }
    



}
