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
    @IBOutlet weak var MKMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set default region to Barrie, Ontario
                let barrieLocation = CLLocationCoordinate2D(latitude: 44.3894, longitude: -79.6903)
                let region = MKCoordinateRegion(center: barrieLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
                MKMapView.setRegion(region, animated: true)
    }
    



}
