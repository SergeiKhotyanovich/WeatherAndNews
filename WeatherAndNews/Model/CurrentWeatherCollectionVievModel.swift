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

