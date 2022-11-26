
import Foundation
import CoreLocation

protocol NetworkServiceProtokol: NSObject {
    func getWeather(location: Location, completion: @escaping (Result<WeatherCurrentModel?, Error>) -> Void )
    func getWeatherForecast(location: Location, completion: @escaping (Result<WeatherForecastModel?, Error>) -> Void)
    func getSearchCity(city: String, completion: @escaping (Result<LocationCityModel?, Error>) -> Void)
}

class NetworkService:NSObject, NetworkServiceProtokol {
    
    func getWeather(location: Location, completion: @escaping (Result<WeatherCurrentModel?, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.lotitude)&lon=\(location.longitude)&appid=fe0a8df10334d41e9f5615b5cbca266f&units=metric"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode(WeatherCurrentModel.self, from: data!)
                completion(.success(obj))
            } catch{
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getWeatherForecast(location: Location,  completion: @escaping (Result<WeatherForecastModel?, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.lotitude)&lon=\(location.longitude)&appid=fe0a8df10334d41e9f5615b5cbca266f&units=metric"
        
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(WeatherForecastModel.self, from: data)
               
                completion(.success(obj))
            } catch{
                
            }
        }.resume()
    }
    
    func getSearchCity(city: String,  completion: @escaping (Result<LocationCityModel?, Error>) -> Void) {
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=5&appid=fe0a8df10334d41e9f5615b5cbca266f"
        
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)

        
        URLSession.shared.dataTask(with: urlRequest) {  data, response, error in
            guard let data = data else { return }
            do {
                let obj = try JSONDecoder().decode(LocationCityModel.self, from: data)
                completion(.success(obj))
            } catch{
                
            }
        }.resume()
    }
    
    
    
}
