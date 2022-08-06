//
//  WeatherBuilder.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 31.03.22.
//

import Foundation

final class WeatherBuilder{
    static func build() -> WeatherViewController{
        let view = WeatherViewController()
        let networkService = NetworkService()
        let locationManager = LocationManager()
      
        let presenter = WeatherPresenter(view: view, networkService: networkService, locationManager: locationManager)
        
        view.presenter = presenter
        return view
    }
      
    
    
    
    
    
}
