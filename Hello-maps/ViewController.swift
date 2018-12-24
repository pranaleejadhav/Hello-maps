//
//  ViewController.swift
//  Hello-maps
//
//  Created by Pranalee Jadhav on 11/30/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //ask for permissions to access location
        
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //ll take some more time as compared to other accuracies
        
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true // show current location
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        mapView.setRegion(region, animated: true)
    }

    @IBAction func changeMapView(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .satellite
            case 2:
                mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
    }
    
    @IBAction func showAnnotation(_ sender: Any) {
        let annotation1 = CustomAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 35.202720, longitude: -80.829710)
        annotation1.title = "UNCC"
        annotation1.subtitle = "best university"
        annotation1.imageURL = "coffee-pin.png"
        
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 35.352300, longitude: -80.684830)
        annotation2.title = "Speedway"
        
        
        mapView.addAnnotations([annotation1, annotation2])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation {
           
            //var customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotationView")
            
            var customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotationView") as? MKMarkerAnnotationView
            
            if customAnnotationView == nil {
                //customAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotationView")
                
                //to change marker
                customAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotationView")
                customAnnotationView?.glyphText = "🎓"
                customAnnotationView?.markerTintColor = UIColor.white
                //customAnnotationView?.glyphTintColor = UIColor.white
                
                customAnnotationView?.canShowCallout = true //to show data in bubble
            } else {
                customAnnotationView?.annotation = annotation
            }
            
            /*
            if let customAnnotation = annotation as? CustomAnnotation {
                customAnnotationView?.image = UIImage(named: customAnnotation.imageURL)
            }*/
            //configureView(customAnnotationView)
            return customAnnotationView
            
        } else {
             return nil
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomAnnotation else {
            return
        }
        
        let customCallOut = CustomCalloutView(annotation: annotation)
        customCallOut.add(to: view)
        
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.subviews.forEach{ subview in
            subview.removeFromSuperview()
            
        }
    }
    
    private func configureView(_ annotationView :MKAnnotationView?) {
        
        let view = UIView(frame: CGRect.zero)
        let viewSize = CGSize(width: 200, height: 200)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: viewSize.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: viewSize.height).isActive = true
        /*view.backgroundColor = UIColor.red
        
        annotationView?.leftCalloutAccessoryView = UIImageView(image: UIImage(named :"coffee-pin"))
        annotationView?.rightCalloutAccessoryView = UIImageView(image: UIImage(named :"coffee-pin"))
        annotationView?.detailCalloutAccessoryView = view*/
        
        let options = MKMapSnapshotter.Options()
        options.size = viewSize
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: (annotationView?.annotation?.coordinate)!, fromDistance: 10, pitch: 65, heading: 0) //pitch is angle
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
               imageView.image = snapshot.image
                view.addSubview(imageView)
            }
        }
        annotationView?.detailCalloutAccessoryView = view
        
    }
    
}

class CustomAnnotation: MKPointAnnotation {
    
    var imageURL :String!
}

