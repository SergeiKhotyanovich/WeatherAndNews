
import Foundation

protocol MapPresenterProtokol: NSObject {
    init(view: MapViewControllerProtocoll, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol)

}

final class MapPresenter: NSObject, MapPresenterProtokol{
    
    private weak var view: MapViewControllerProtocoll?
    private weak var networkService: NetworkServiceProtokol?
    private weak var locationManager: LocationManagerProtocol?
    
   required init(view: MapViewControllerProtocoll, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol) {
       self.networkService = networkService
       self.locationManager = locationManager
       super.init()
       self.view = view
    }

}
