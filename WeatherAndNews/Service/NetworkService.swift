//
//  LocationsServise.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 16.04.22.
//

import Foundation
import CoreLocation

protocol NetworkServiceProtokol: NSObject{
    func getWeather(location: Location, completion: @escaping (Result<WeatherModel?, Error>) -> Void )
}

class NetworkService:NSObject, NetworkServiceProtokol{
    
    func getWeather(location: Location, completion: @escaping (Result<WeatherModel?, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.lotitude)&lon=\(location.longitude)&appid=fe0a8df10334d41e9f5615b5cbca266f&units=metric"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(WeatherModel.self, from: data!)
                print(obj)
                completion(.success(obj))
            } catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    
}
