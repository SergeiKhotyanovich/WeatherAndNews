
import Foundation
import UIKit

struct ForecastWeatherViewModel {
    var days: [ForecastForDayModel]
    var collectionViewForHourModels: [[ForecastForHourCollectionViewModel]]
}


struct ForecastForDayModel {
    var day: String
}

struct ForecastForHourCollectionViewModel {
    var hour: String
    var temperature: String
    var description: String
    var image: UIImage
    var pressure: String
    var humidity: String
    var visibility: String
    var feelsLike: String
    var windiness: String
}
