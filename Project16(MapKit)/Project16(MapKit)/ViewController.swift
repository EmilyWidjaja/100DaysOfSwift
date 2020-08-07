//
//  ViewController.swift
//  Project16(MapKit)
//
//  Created by Emily Widjaja on 20/7/20.
//  Copyright © 2020 Emily Widjaja. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var urlToLoad: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Allows users to select mapType
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(chooseMapType))
        
        //add info specific
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        //adds pins
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    //shows alert that allows users to specify how they want to view the map
    @objc func chooseMapType() {
        let ac = UIAlertController(title: "Choose map view", message: "", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = MKMapType.standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.mapType = MKMapType.satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
            self?.mapView.mapType = MKMapType.hybrid
        })
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = MKMapType.satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Hybrid Flyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = MKMapType.hybridFlyover
        })
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = MKMapType.mutedStandard
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
   /* func setMapType(action: UIAlertAction) {
        let mapType = action.title
        mapView.mapType = MKMapView.mapType
    }*/
    
    //shows annotation if clicked
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {return nil}
        
        let identifier = "Capital"
        
        //if not one of our recognised capitals, use apple's default annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            let webbtn = UIButton(type: .contactAdd)  //button to click to show web page w/ more info
            annotationView?.rightCalloutAccessoryView = btn
            annotationView?.leftCalloutAccessoryView = webbtn
            
        } else { //use apple's default annotation & don't show button
            annotationView?.annotation = annotation
        }
        annotationView?.pinTintColor = .purple   //challenge 1
        return annotationView
    }

    //when accessory tapped, do action - need to differentiate between accessories
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {return}   //make sure is capital
        let placeName = capital.title

        if control == view.rightCalloutAccessoryView {  //if normal info button tapped
            let placeInfo = capital.info
            let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        } else {    //if webView button tapped
            switch placeName {
            case "Washington DC":
                urlToLoad = "https://en.wikipedia.org/wiki/Washington,_D.C."
            default:
                urlToLoad = "https://en.wikipedia.org/wiki/" + placeName!
            }
            let vc = storyboard?.instantiateViewController(identifier: "WebView") as? webViewController
            vc?.websiteToLoad = urlToLoad
            present(vc!, animated: true)
            
        }
            
    }
}

