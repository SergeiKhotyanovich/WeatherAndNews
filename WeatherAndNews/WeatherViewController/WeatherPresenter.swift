
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
    
    var weather: WeatherModel? {get set}
    var weatherForecast: WeatherForecastModel? {get set}
    var sityModel: Welcome?{get set}
    var forecastWeatherView: ForecastWeatherViewModel? { get set }
    var numberOfSections:[String]{get set}
    var numberOfRows:[String]{get set}
}

final class WeatherPresenter: NSObject, weatherPresenterProtocol{
   
    
    var weather: WeatherModel?
    var weatherForecast: WeatherForecastModel?
    var forecastWeatherView: ForecastWeatherViewModel?
    var sityModel: Welcome?
    
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
        guard let sityModel = sityModel else {
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
                    self.weather = weather
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
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.weatherForecast = weather
                    self.forecastWeatherView = self.prepareForecastWeatherViewModel(data: self.weatherForecast!)
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
                    self.sityModel = sity
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
                description:
                    DataSource.weatherIDs[hour.weather[0].id ] ?? "",
                  
                image: WeatherImages.getWeatherPic(
                    name: hour.weather[0].icon
                ) ?? UIImage.systemNamed("sun.max")
            )
            
            hourModel.append(model)
//            print("\(hourModel), \(number)")
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
            
            view?.updateTableView(numberOfSections: numberOfSections, numberOfRows: numberOfRows)
            numberOfRows = []
            numberOfSections = []
        }
    }
      
    
    
    
    func showFitstView() {
        
    }
    
    func showSecondView() {
        
    }
}







