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
    let firstMapCenter = CLLocationCoordinate2D(latitude: 37.6575233, longitude: -122.4020735)
    let firstMapSpan = MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.14)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        reload()
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

    func reload() {
        ServerAPI.markets(resultFunc: {
            success, _ in
            if success {
                //self.createChallengesView()
                print("OK")
            } else {
                print("NG")
            }
        })
    }
}
