//
//  WeatherPresenter.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 31.03.22.
//

import Foundation
import UIKit
import CoreLocation

protocol weatherPresenterProtocol: NSObject{
    init(view:weatherViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol)
    func updateWeatherButtonPressed()
    func showFitstView()
    func showSecondView()
    func getWeather(location: Location)
    var weather: WeatherModel? {get set}
}

final class WeatherPresenter: NSObject, weatherPresenterProtocol{
   
    
    var weather: WeatherModel?
    
    private weak var view: weatherViewControllerProtocol?
    private var networkService: NetworkServiceProtokol
    private var locationManager: LocationManagerProtocol

    required init(view: weatherViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol) {
        self.networkService = networkService
        self.locationManager = locationManager
        super.init()
        self.view = view
    }
    
    func updateWeatherButtonPressed() {
        locationManager.updateLocation()
        locationManager.location = { [weak self] result in
            self?.getWeather(location: result)
        }
    }
    
    func getWeather(location: Location) {
        networkService.getWeather(location: location, completion: { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weather = weather
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    func showFitstView() {
        
    }
    
    func showSecondView() {
        
    }
}







