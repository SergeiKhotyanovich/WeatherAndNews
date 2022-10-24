//
//  CurrentWeatherViewModel.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import Foundation
import UIKit




struct CurrentWeatherCollectionViewModel {
    let weatherPicture: UIImage
    let sityLabel: String
    let weatherLabel: String
    let tempLabel: String
    let currentWeatherCollectionModel: CurrentWeatherCollectionModel
}


struct CurrentWeatherViewModel {
    let weatherPicture:UIImage
    let sityLabel:String
    let weatherLabel:String
    let tempLabel:String
    let currentWeatherCollectionModel: CurrentWeatherCollectionModel
}


struct CurrentWeatherCollectionModel {
    let pressure: Pressure
    let humidity: Humidity
    let windSpeed: WindSpeed
    let visibility: Visibility
    let сloudiness: Сloudiness
    let feelsLike: FeelsLike
    let rainfall: Rainfall
    let tempMax: TempMax
    let tempMin: TempMin
}

struct Pressure {
    let image = UIImage(systemName: "thermometer")
    let descriptions: String
    
}

struct Humidity {
    let image = UIImage(systemName: "humidity")
    let descriptions: String
}

struct WindSpeed {
    let image = UIImage(systemName: "wind")
    let descriptions: String
}

struct Visibility {
    let image = UIImage(systemName: "eye.fill")
    let descriptions: String
}

struct Сloudiness {
    let image = UIImage(systemName: "smoke.fill")
    let descriptions: String
}

struct FeelsLike {
    let image = UIImage(systemName: "figure.stand")
    let descriptions: String
}

struct Rainfall {
    let image = UIImage(systemName: "cloud.heavyrain")
    let descriptions: String
}

struct TempMax {
    let image = UIImage(systemName: "sun.max.fill")
    let descriptions: String
}

struct TempMin {
    let image = UIImage(systemName: "sun.min")
    let descriptions: String
}
