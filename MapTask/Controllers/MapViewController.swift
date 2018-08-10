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

        let url = Bundle.main.url(forResource: ArtConstants.resouceName, withExtension: ArtConstants.resourceType)
        let parser = JSONParser(url: url!)
        
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
                
                guard let latitude = item[ArtConstants.JSONKeys.latitudeIndex] as? String else {
                    print("Unexpected latitude type")
                    return
                }
                guard let longitude = item[ArtConstants.JSONKeys.longitudeIndex] as? String else {
                    print("Unexpected longitude type")
                    return
                }
                
                let title = item[ArtConstants.JSONKeys.titleIndex] as? String
                let subtitle = item[ArtConstants.JSONKeys.subtitleIndex] as? String
                let description = item[ArtConstants.JSONKeys.descriptionIndex] as? String

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
        
        if annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude {
            let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as! MKMarkerAnnotationView
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIndentifier.sightAnnotationViewIndentifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIndentifier.sightAnnotationViewIndentifier)
                view.canShowCallout = true
                
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







