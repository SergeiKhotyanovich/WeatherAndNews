
import Foundation
import UIKit
import CoreLocation

protocol weatherPresenterProtocol: NSObject {
    init(view:WeatherViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol)
    
    var weatherCurrentModel: WeatherCurrentModel? {get set}
    var weatherForecastModel: WeatherForecastModel? {get set}
    var searсhСityModel: LocationCityModel?{get set}
    var currentWeatherViewModel: CurrentWeatherViewModel?{ get set }
    var forecastWeatherView: ForecastWeatherViewModel? { get set }
    var numberOfSections:[String]{get set}
    var numberOfRows:[String]{get set}
    
    func updateWeatherButtonPressed()
    func getWeather(location: Location)
    func getWeatherForecast(location: Location)
    func getSearchCity(city: String)
    func getDayOfTheWeek()
    func updateMapViewWeatherButtonPressed(location: Location)
}

final class WeatherPresenter: NSObject, weatherPresenterProtocol {
    
    var weatherCurrentModel: WeatherCurrentModel?
    var weatherForecastModel: WeatherForecastModel?
    var forecastWeatherView: ForecastWeatherViewModel?
    var currentWeatherViewModel: CurrentWeatherViewModel?
    var searсhСityModel: LocationCityModel?
    
    let dateFormatter = DateFormatter()
    let date = NSDate()
    var numberOfSections:[String] = []
    var numberOfRows:[String] = []
    
    private weak var view: WeatherViewControllerProtocol?
    private var networkService: NetworkServiceProtokol
    private var locationManager: LocationManagerProtocol
    
    required init(view: WeatherViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol) {
        self.networkService = networkService
        self.locationManager = locationManager
        super.init()
        self.view = view
    }
    
    func updateWeatherButtonPressed() {
        locationManager.updateLocation()
        locationManager.location = { [weak self] result in
            self?.getWeather(location: result)
            self?.getWeatherForecast(location: result)
        }
    }
    
    func updateMapViewWeatherButtonPressed(location: Location) {
        getWeather(location: location)
        getWeatherForecast(location: location)
        
    }
    
    func updateSearchWeatherButtonPressed() {
        guard let searсhСityModel = searсhСityModel else {
            return
        }
        let location = Location(longitude: String(searсhСityModel.first?.lon ?? 0),
                                lotitude: String(searсhСityModel.first?.lat ?? 0))
        
        getWeather(location: location)
        getWeatherForecast(location: location)
    }
    
    func getWeather(location: Location) {
        networkService.getWeather(location: location, completion: { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weatherCurrentModel = weather
                    self.currentWeatherViewModel = self.prepereCurrentWeatherViewModel(data: self.weatherCurrentModel!)
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    func getWeatherForecast(location: Location) {
        networkService.getWeatherForecast(location: location, completion:  { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let weather):
                    self.weatherForecastModel = weather
                    self.forecastWeatherView = self.prepareForecastWeatherViewModel(data: self.weatherForecastModel!)
                    self.updateCurrentView(dataCurrent: self.weatherCurrentModel!, dataForecast: self.weatherForecastModel!)
                    self.view?.successForecasView()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    func getSearchCity(city: String) {
        networkService.getSearchCity(city: city, completion:  { [weak self] result in
            
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let city):
                    let check = city?.first?.name.count
                    if check == nil {
                        self.view?.showAlert()
                    }else{
                        self.searсhСityModel = city
                        self.updateSearchWeatherButtonPressed()
                        self.addOnlyUniqueSities()
                    }
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    func addOnlyUniqueSities() {
        guard let city = searсhСityModel else { return }
        
        if !PreservationOfPopularCities.shared.popularCities.contains(city.first!.name) {
            
            PreservationOfPopularCities.shared.popularCities.insert(city.first!.name, at: 0)
        }
    }
    
    private func prepareForecastWeatherViewModel(data: WeatherForecastModel) -> ForecastWeatherViewModel {
        let dateFormatter = DateFormatter()
        var hourModel = [ForecastForHourCollectionViewModel]()
        var daysModels = [ForecastForDayModel]()
        dateFormatter.locale = Locale(identifier: "en_RU")
        
        for (_, hour) in data.list.enumerated(){
            dateFormatter.dateFormat = "HH:mm"
            let model = ForecastForHourCollectionViewModel(
                hour: dateFormatter.string(from: Date(timeIntervalSince1970: Double(hour.dt))),
                temperature: "\(Int(hour.main.temp))",
                description: DataSource.weatherIDs[hour.weather[0].id ] ?? "",
                image: WeatherImages.getWeatherPic(name: hour.weather[0].icon) ?? UIImage.systemNamed("sun.max"),
                pressure: "\(Int(hour.main.pressure))hPa",
                humidity: "\(Int(hour.main.humidity))%",
                visibility: "\(Int(hour.visibility))M",
                feelsLike: "\(Int(hour.main.feelsLike))°C",
                windiness: "\(Int(hour.wind.speed))m/s"
            )
            
            hourModel.append(model)
        }
        for (_, day) in data.list.enumerated() {
            dateFormatter.dateFormat = "EEEE"
            let model = ForecastForDayModel(
                day: dateFormatter.string(from: Date(timeIntervalSince1970: Double(day.dt)))
            )
            daysModels.append(model)
        }
        return ForecastWeatherViewModel(days: daysModels, collectionViewForHourModels: hourModel)
    }
    
    func getDayOfTheWeek() {
        dateFormatter.locale = Locale(identifier: "en_RU")
        dateFormatter.dateFormat = "EEEE"
        let stringDate: String = dateFormatter.string(from: date as Date)
        numberOfSections.append(stringDate)
        numberOfRows.append(stringDate)
        if (forecastWeatherView?.days) != nil{
            for day in forecastWeatherView!.days{
                let uniqueDay = day.day
                if uniqueDay != numberOfSections[numberOfSections.count - 1]{
                    numberOfSections.append(uniqueDay)
                }
            }
            for day in forecastWeatherView!.days{
                let uniqueDay = day.day
                if uniqueDay == numberOfRows[0]{
                    numberOfRows.append(uniqueDay)
                }
            }
            
            view?.successSectionCount(numberOfSections: numberOfSections, numberOfRows: numberOfRows)
            numberOfRows = []
            numberOfSections = []
        }
    }
    
    func prepereCurrentWeatherViewModel(data: WeatherCurrentModel) -> CurrentWeatherViewModel {
        let currentWeatherCollectionViewModel = self.prepareCurrentWeatherCollectionVievModel(data: data)
        let model = CurrentWeatherViewModel(
            weatherPicture: WeatherImages.getWeatherPic(name: (data.weather[0].icon))!,
            cityLabel: data.name,
            weatherLabel: DataSource.weatherIDs[data.weather[0].id]!,
            tempLabel: "\(Int(data.main.temp))°",
            currentWeatherCollectionVievModel: currentWeatherCollectionViewModel[0])
        
        return model
    }
    
    func prepareCurrentWeatherCollectionVievModel(data: WeatherCurrentModel) -> [[CurrentWeatherCollectionVievModel]] {
        let parameters = [
            WeatherParameters.pressure,
            WeatherParameters.humidity,
            WeatherParameters.windSpeed,
            WeatherParameters.visibility,
            WeatherParameters.сloudiness,
            WeatherParameters.feelsLike,
            WeatherParameters.rainfall,
            WeatherParameters.tempMax,
            WeatherParameters.tempMin
        ]
        var outModels = [[CurrentWeatherCollectionVievModel]]()
        var models = [CurrentWeatherCollectionVievModel]()
        
        for parameter in parameters {
            var model: CurrentWeatherCollectionVievModel
            switch parameter {
            case .pressure:
                model = CurrentWeatherCollectionVievModel(description: "\(data.main.pressure)hPa", image: WeatherImages.pressure!)
            case .humidity:
                model = CurrentWeatherCollectionVievModel(description: "\(data.main.humidity)%", image: WeatherImages.humidity!)
            case .windSpeed:
                model = CurrentWeatherCollectionVievModel(description: "\(Int(data.wind.speed))m/s", image: WeatherImages.windSpeed!)
            case .visibility:
                model = CurrentWeatherCollectionVievModel(description: "\(data.visibility)M", image: WeatherImages.visibility!)
            case .сloudiness:
                model = CurrentWeatherCollectionVievModel(description: "\(data.clouds.all)%", image: WeatherImages.сloudiness!)
            case .feelsLike:
                model = CurrentWeatherCollectionVievModel(description: "\(Int(data.main.feelsLike))°C", image: WeatherImages.feelsLike!)
            case .rainfall:
                model = CurrentWeatherCollectionVievModel(description: "\(data.clouds.all)%", image: WeatherImages.rainfall!)
            case .tempMax:
                model = CurrentWeatherCollectionVievModel(description: "\(Int(data.main.tempMax))°C", image: WeatherImages.tempMax!)
            case .tempMin:
                model = CurrentWeatherCollectionVievModel(description: "\(Int(data.main.tempMin))°C", image: WeatherImages.tempMin!)
            }
            models.append(model)
        }
        outModels.append(models)
        return outModels
    }

    private func updateCurrentView(dataCurrent: WeatherCurrentModel, dataForecast: WeatherForecastModel) {
        DispatchQueue.main.async {
            let currentWeatherViewModel = self.prepereCurrentWeatherViewModel(data: dataCurrent)
            let forecastWeatherViewModel = self.prepareForecastWeatherViewModel(data: dataForecast)
            self.view?.successGettingData(currentWeatherViewModel: currentWeatherViewModel, forecastWeatherViewModel: forecastWeatherViewModel)
        }
    }
}







