//
//  ForecastWeatherViewModel.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 22.08.22.
//

import Foundation
import UIKit

struct ForecastWeatherViewModel{
    var days: [ForecastForDayModel]
    var collectionViewForHourModels: [ForecastForHourCollectionViewModel]
}


struct ForecastForDayModel {
    var day: String
}

struct ForecastForHourCollectionViewModel {
    var hour: String
    var temperature: String
    var description: String
    var image: UIImage

}
