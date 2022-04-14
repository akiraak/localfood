//
//  LocationsViewController.swift
//  localfood
//
//  Created by Akira Kozakai on 3/12/22.
//

import UIKit
import MapKit

class MarketAnnotation: MKPointAnnotation {
    let market: Market!

    init(market: Market) {
        self.market = market
    }
}

class MarketsViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var marketCardView: MarketCardView? = nil
    let firstMapCenter = CLLocationCoordinate2D(latitude: 37.6575233, longitude: -122.4020735)
    let firstMapSpan = MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.14)
    var annotations: [MKPointAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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

        /*
        let annotation = MKPointAnnotation()
        //ピンの位置
        let latitude = 37.7554447
        let longitude = -122.4209648
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        //ピンにメッセージを付随する
        annotation.title = "タイトル"
        annotation.subtitle = "サブタイトル"
        //ピンを追加
        mapView.addAnnotation(annotation)
        */
    }

    func reload() {
        ServerAPI.markets(resultFunc: {
            success, _ in
            if success {
                print("OK")
                self.mapView.removeAnnotations(self.annotations)
                self.annotations = []
                //self.createChallengesView()
                for market in Markets.shared!.markets {
                    //let annotation = MKPointAnnotation()
                    let annotation = MarketAnnotation(market: market)
                    //ピンの位置
                    let latitude = Double(market.lat)
                    let longitude = Double(market.lng)
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    //ピンにメッセージを付随する
                    //annotation.title = "タイトル"
                    //annotation.subtitle = "サブタイトル"
                    self.annotations.append(annotation)
                }
                self.mapView.addAnnotations(self.annotations)
            } else {
                print("NG")
            }
        })
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MarketAnnotation {
            print(annotation.market.name)
            if marketCardView != nil {
                marketCardView?.removeFromSuperview()
            }
            marketCardView = UINib(nibName: "MarketCardView", bundle: nil)
                        .instantiate(withOwner: nil, options: nil)
                        .first as? MarketCardView
            marketCardView!.frame.origin = CGPoint(
                x: 20,
                y: self.mapView.frame.height - marketCardView!.frame.size.height - 20)
            marketCardView!.frame.size = CGSize(
                width: self.view.frame.width - 40,
                height: marketCardView!.frame.size.height)
            marketCardView!.setup(annotation.market)
            self.mapView.addSubview(marketCardView!)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if marketCardView != nil {
            marketCardView?.removeFromSuperview()
            marketCardView = nil
        }
    }

    @IBAction func pushAdd(_ sender: Any) {
        print("aaa")
    }
}
