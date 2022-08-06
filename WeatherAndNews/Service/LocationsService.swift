//
//  LocationsModel.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 8.06.22.
//

import UIKit
import CoreLocation

protocol LocationManagerProtocol: NSObject{
    var location: ((Location)->Void)? { get set }

    func updateLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {

    let locationManager = CLLocationManager()
    
    var location: ((Location)->Void)?
    
    func updateLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.pausesLocationUpdatesAutomatically = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocatin = locations.last {
            let latitude = String(format: "%f", lastLocatin.coordinate.latitude)
            let langitude = String(format:"%f", lastLocatin.coordinate.longitude)
            print(latitude,langitude)
            
            location?(Location(longitude: langitude, lotitude: latitude)) 
            
            
            
        }
    }
}
