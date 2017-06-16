//
//  ViewController.swift
//  FindRestaurants
//
//  Created by Rajesh Kommana on 16/6/17.
//  Copyright © 2017 Rajesh Kommana. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var restaurant: Restaurant?
    var distanceInKM: String?
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation?

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var nameOfRestaurant: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = restaurant!.name
        addMap()
        displayDetails()
        addGeoLocation()
    }
    
    func addGeoLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
    }
    
    func addMap() {
        
        let lat = restaurant!.latitude!
        let lng = restaurant!.longitude!
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let location = CLLocationCoordinate2DMake(lat, lng)
        let region = MKCoordinateRegionMake(location, span)
        map.setRegion(region, animated: true)
        
    
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = restaurant!.name
        annotation.subtitle = restaurant!.address
        map.addAnnotation(annotation)
    }
    
    func displayDetails() {
        nameOfRestaurant.text = restaurant!.name
        distance.text = distanceInKM
        openLabel(open: restaurant!.open!)
        //ratingLabel.text = "⭐"
        let ratingText = displayRatingStars(rating: restaurant!.rating!)
        ratingLabel.text = ratingText
    }
    
    func openLabel(open: Bool) {
        if open {
            
            openNowLabel.text = "Open"
            openNowLabel.textColor = UIColor.green
        } else {
            openNowLabel.text = "Closed"
            openNowLabel.textColor = UIColor.red
        }
    }
    
    func displayRatingStars(rating: Int) -> String {
        
        var ratingStar: String?
        
        switch rating {
        case 0:
            ratingStar = ""
        case 1:
            ratingStar = "⭐"
        case 2:
            ratingStar = "⭐⭐"
        case 3:
            ratingStar = "⭐⭐⭐"
        case 4:
            ratingStar = "⭐⭐⭐⭐"
        case 5:
            ratingStar = "⭐⭐⭐⭐⭐"
            
        default:
            ratingStar = ""
        }
        
        return ratingStar!
    }



}

extension ViewController: MKMapViewDelegate{
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
        displayRoutes()
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.darkGray
        renderer.lineWidth = 4.0
        return renderer
        
        
    }
    
    func displayRoutes(){
        
        if userLocation != nil {
            
            // locations
            let sourceLocation = CLLocation(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
            let destinationLocation = CLLocation(latitude: restaurant!.latitude!, longitude: restaurant!.longitude!)
            
            // placemarks
            let sourcePlacemarks = MKPlacemark(coordinate: sourceLocation.coordinate, addressDictionary: nil)
            let destinationPlacemarks = MKPlacemark(coordinate: destinationLocation.coordinate, addressDictionary: nil)
            
            // region
            let region = MKCoordinateRegionMakeWithDistance(sourceLocation.coordinate, 20000, 20000)
            map.delegate = self
            
            // request 
            
            let request = MKDirectionsRequest()
            request.source = MKMapItem(placemark: sourcePlacemarks)
            request.destination = MKMapItem(placemark: destinationPlacemarks)
            request.requestsAlternateRoutes = false
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate(completionHandler: { (response, error) in
                if error == nil {
                    
                    for route in response!.routes {
                        self.map.add(route.polyline)
                        
                    }
                    
                    
                } else {
                    print("error displaying route informatiion")
                    print(error?.localizedDescription)
                }
            })
            
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

