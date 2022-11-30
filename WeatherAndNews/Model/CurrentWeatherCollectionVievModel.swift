//
//  CurrentWeatherViewModel.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.10.22.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    let weatherPicture: UIImage
    let cityLabel: String
    let weatherLabel: String
    let tempLabel: String
    let currentWeatherCollectionVievModel: [CurrentWeatherCollectionVievModel]
}

struct CurrentWeatherCollectionVievModel {
    let description: String
    let image: UIImage
}

//struct Pressure {
//    let image = UIImage(systemName: "thermometer")
//    let descriptions: String
//    
//}
//
//struct Humidity {
//    let image = UIImage(systemName: "humidity")
//    let descriptions: String
//}
//
//struct WindSpeed {
//    let image = UIImage(systemName: "wind")
//    let descriptions: String
//}
//
//struct Visibility {
//    let image = UIImage(systemName: "eye.fill")
//    let descriptions: String
//}
//
//struct Сloudiness {
//    let image = UIImage(systemName: "smoke.fill")
//    let descriptions: String
//}
//
//struct FeelsLike {
//    let image = UIImage(systemName: "figure.stand")
//    let descriptions: String
//}
//
//struct Rainfall {
//    let image = UIImage(systemName: "cloud.heavyrain")
//    let descriptions: String
//}
//
//struct TempMax {
//    let image = UIImage(systemName: "sun.max.fill")
//    let descriptions: String
//}
//
//struct TempMin {
//    let image = UIImage(systemName: "sun.min")
//    let descriptions: String
//}
//

