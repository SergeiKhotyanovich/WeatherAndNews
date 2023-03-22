
    import Foundation
    import CoreLocation

    protocol NetworkServiceProtokol: NSObject {
    func getCurrentWeather(location: Location, temperature: String, language: String, completion: @escaping (Result<WeatherCurrentModel?, Error>) -> Void )
    func getForecastWeather(location: Location,temperature: String, language: String, completion: @escaping (Result<WeatherForecastModel?, Error>) -> Void)
    func getFoundCity(city: String, completion: @escaping (Result<LocationCityModel?, Error>) -> Void)
    //    func getJSONData<T: Decodable>(location: Location, completion: @escaping (T?) -> Void)
    }

    class NetworkService: NSObject, NetworkServiceProtokol {

        func getCurrentWeather(location: Location, temperature: String, language: String, completion: @escaping (Result<WeatherCurrentModel?, Error>) -> Void) {
           let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.lotitude)&lon=\(location.longitude)&lang=\(UserLanguagePreservation.shared.userLanguage)&appid=fe0a8df10334d41e9f5615b5cbca266f&units=\(UserTemperaturePreservation.shared.userTemperature)"
            
            execute(urlRequest: getUrlRequest(urlString: urlString), completion: completion)
        }

        func getForecastWeather(location: Location, temperature: String, language: String, completion: @escaping (Result<WeatherForecastModel?, Error>) -> Void) {
            let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.lotitude)&lon=\(location.longitude)&lang=\(language)&appid=fe0a8df10334d41e9f5615b5cbca266f&units=\(temperature)"
            
            execute(urlRequest: getUrlRequest(urlString: urlString), completion: completion)
        }

        func getFoundCity(city: String,  completion: @escaping (Result<LocationCityModel?, Error>) -> Void) {
            let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=5&appid=fe0a8df10334d41e9f5615b5cbca266f"
            
            execute(urlRequest: getUrlRequest(urlString: urlString), completion: completion)
        }

        private func getUrlRequest(urlString: String) -> URLRequest {
            
            guard let url = URL(string: urlString) else { return URLRequest(url: URL(fileURLWithPath: ""))}
            return URLRequest(url: url)
        }

        private func execute<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T?, Error>) -> Void) {
            
            URLSession.shared.dataTask(with: urlRequest) {  data, response, error in
                guard let data = data else { return }
                do {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(obj))
                } catch{
                    completion(.failure(error))
                }
            }.resume()
        }
    }
