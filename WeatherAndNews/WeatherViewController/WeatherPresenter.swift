
import Foundation
import UIKit
import CoreLocation

protocol weatherPresenterProtocol: NSObject{
    init(view:weatherViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol)
    func updateWeatherButtonPressed()
    func showFitstView()
    func showSecondView()
    func getWeather(location: Location)
    func getWeatherForecast(location: Location)
    func getSearchSity(sity: String)
    func getDayOfTheWeek()
    
    var weatherCurrent: WeatherCurrentModel? {get set}
    var weatherForecast: WeatherForecastModel? {get set}
    var cityModel: LocationCityModel?{get set}
    var currentWeatherViewModel: CurrentWeatherCollectionViewModel?{ get set }
    var forecastWeatherView: ForecastWeatherViewModel? { get set }
    var numberOfSections:[String]{get set}
    var numberOfRows:[String]{get set}
}

final class WeatherPresenter: NSObject, weatherPresenterProtocol{
    
    var weatherCurrent: WeatherCurrentModel?
    var weatherForecast: WeatherForecastModel?
    var forecastWeatherView: ForecastWeatherViewModel?
    var currentWeatherViewModel: CurrentWeatherCollectionViewModel?
    var cityModel: LocationCityModel?
    
    let dateFormatter = DateFormatter()
    let date = NSDate()
    var numberOfSections:[String] = []
    var numberOfRows:[String] = []
    
    private weak var view: weatherViewControllerProtocol?
    private var networkService: NetworkServiceProtokol
    private var locationManager: LocationManagerProtocol
    
    required init(view: weatherViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol) {
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
    
    func updateWeatherButtonOKPressed() {
        guard let sityModel = cityModel else {
            return
        }
        let location = Location(longitude: String(sityModel.first?.lon ?? 0),
                                lotitude: String(sityModel.first?.lat ?? 0))
        
        getWeather(location: location)
        getWeatherForecast(location: location)
        
    }
    
    func getWeather(location: Location) {
        networkService.getWeather(location: location, completion: { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weatherCurrent = weather
                    self.currentWeatherViewModel = self.prepereCurrentWeatherViewModel(data: self.weatherCurrent!)
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
                    self.weatherForecast = weather
                    self.forecastWeatherView = self.prepareForecastWeatherViewModel(data: self.weatherForecast!)
                    self.updateCurrentView(dataCurrent: self.weatherCurrent!, dataForecast: self.weatherForecast!)
                    self.view?.successForecasView()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    func getSearchSity(sity: String) {
        networkService.getSearchSity(sity: sity, completion:  { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let sity):
                    self.cityModel = sity
                    self.updateWeatherButtonOKPressed()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        })
    }
    
    private func prepareForecastWeatherViewModel(data: WeatherForecastModel) -> ForecastWeatherViewModel {
        let dateFormatter = DateFormatter()
        var hourModel = [ForecastForHourCollectionViewModel]()
        var daysModels = [ForecastForDayModel]()
        
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
    
    func prepereCurrentWeatherViewModel(data: WeatherCurrentModel) -> CurrentWeatherCollectionViewModel {
        let model = CurrentWeatherCollectionViewModel(
            weatherPicture: WeatherImages.getWeatherPic(name: (data.weather[0].icon))!,
            sityLabel: data.name,
            weatherLabel: DataSource.weatherIDs[data.weather[0].id]!,
            tempLabel: "\(Int(data.main.temp))°C",
            currentWeatherCollectionModel: CurrentWeatherCollectionModel(
                pressure: Pressure(descriptions: "\(data.main.pressure)hPa"),
                humidity: Humidity(descriptions: "\(data.main.humidity)%"),
                windSpeed: WindSpeed(descriptions: "\(Int(data.wind.speed))m/s"),
                visibility: Visibility(descriptions: "\(data.visibility)M"),
                сloudiness: Сloudiness(descriptions: "\(data.clouds.all)%"),
                feelsLike: FeelsLike(descriptions: "\(Int(data.main.feelsLike))°C"),
                rainfall: Rainfall(descriptions: "\(data.clouds.all)%"),
                tempMax: TempMax(descriptions: "\(Int(data.main.tempMax))°C"),
                tempMin: TempMin(descriptions: "\(Int(data.main.tempMin))°C")))
        
        return model
    }
    
    private func updateCurrentView(dataCurrent: WeatherCurrentModel, dataForecast: WeatherForecastModel) {
        DispatchQueue.main.async {
            let currentWeatherViewModel = self.prepereCurrentWeatherViewModel(data: dataCurrent)
            let forecastWeatherViewModel = self.prepareForecastWeatherViewModel(data: dataForecast)
            self.view?.successGettingData(currentWeatherViewModel: currentWeatherViewModel, forecastWeatherViewModel: forecastWeatherViewModel)
            
        }
    }
    
    func updateForecastView(data: WeatherForecastModel) {
        DispatchQueue.main.async {
           
        }
    }
    
    func showFitstView() {
        
    }
    
    func showSecondView() {
        
    }
}







