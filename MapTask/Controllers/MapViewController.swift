//
//  MapViewController.swift
//  MapTask
//
//  Created by Nikolay Sereda on 19.07.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        
        let urlStr = Bundle.main.path(forResource: Constants.resouceName, ofType: Constants.resourceType)
        let parser = JSONParser(urlString: urlStr!)
        
        putSightAnnotations(from: parser.parseJSON())
    }
    
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    //MARK: Private Methods
    private func putSightAnnotations(from sightData: [Any]) {
        for item in sightData {
            if let item = item as? [Any] {
                let title = item[Constants.titleIndex] as? String
                let subtitle = item[Constants.subtitleIndex] as? String
                let description = item[Constants.descriptionIndex] as? String
                
                let latitude = item[Constants.latitudeIndex] as! String
                let longitude = item[Constants.longitudeIndex] as! String
                let coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                
                let annotation = SightAnnotation(coordinate: coordinate, title: title, subtitle: subtitle, annotationDescription: description)
                
                mapView.addAnnotation(annotation)
            }
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var view: MKMarkerAnnotationView
        let indentifier = "Sight"
        
        if annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude {
            let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as! MKMarkerAnnotationView
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: indentifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
                let button = UIButton(type: .detailDisclosure)
                view.leftCalloutAccessoryView = button
            }
        }
 
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            let annotation = view.annotation as! SightAnnotation
            
            let alert = UIAlertController(title: "Sight description", message: annotation.annotationDescription, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MapViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title! {
        case "Standard":
            mapView.mapType = .standard
        case "Satellite":
            mapView.mapType = .satellite
        case "Hybrid":
            mapView.mapType = .hybrid
        default:
            fatalError("Unexpected type")
        }
    }
}







