
import Foundation
import UIKit

enum WeatherImages {

    static private let condition = [
        (image: UIImage.systemNamed("sun.max.fill"), name: "01d"),
        (image: UIImage.systemNamed("moon.fill"), name: "01d"),
        (image: UIImage.systemNamed("cloud.sun.fill"), name: "02d"),
        (image: UIImage.systemNamed("cloud.moon.fill"), name: "02n"),
        (image: UIImage.systemNamed("cloud"), name: "03d"),
        (image: UIImage.systemNamed("cloud"), name: "03n"),
        (image: UIImage.systemNamed("cloud.fill"), name: "04d"),
        (image: UIImage.systemNamed("cloud.fill"), name: "04n"),
        (image: UIImage.systemNamed("cloud.heavyrain.fill"), name: "09d"),
        (image: UIImage.systemNamed("cloud.heavyrain.fill"), name: "09n"),
        (image: UIImage.systemNamed("cloud.sun.rain.fill"), name: "10d"),
        (image: UIImage.systemNamed("cloud.moon.rain.fill"), name: "10n"),
        (image: UIImage.systemNamed("cloud.bolt.fill"), name: "11d"),
        (image: UIImage.systemNamed("cloud.bolt.fill"), name: "11n"),
        (image: UIImage.systemNamed("snowflake"), name: "13d"),
        (image: UIImage.systemNamed("snowflake"), name: "13n"),
        (image: UIImage.systemNamed("cloud.fog.fill"), name: "50d"),
        (image: UIImage.systemNamed("cloud.fog.fill"), name: "50n"),
    ]

    static func getWeatherPic(name: String) -> UIImage? {
        var image: UIImage? = nil
        for pic in WeatherImages.condition {
            if pic.name == name {
                image = pic.image
            }
        }
        return image
    }
 }

