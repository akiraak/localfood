//
//  LocationsViewController.swift
//  localfood
//
//  Created by Akira Kozakai on 3/12/22.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let firstMapCenter = CLLocationCoordinate2D(latitude: 37.7775233, longitude: -122.4320735)
    let firstMapSpan = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }

    func setupMapView() {
        let region = MKCoordinateRegion(center: firstMapCenter, span: firstMapSpan)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading
        let camera:MKMapCamera = self.mapView.camera;
        camera.pitch += 60
        mapView.setCamera(camera, animated: true)
    }
}
