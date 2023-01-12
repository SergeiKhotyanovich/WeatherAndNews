
import Foundation

protocol MapPresenterProtokol: NSObject {
    init(view: MapViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol)
    func setUserLocation()
}

final class MapPresenter: NSObject, MapPresenterProtokol{
    
    private weak var view: MapViewControllerProtocol?
    private var networkService: NetworkServiceProtokol
    private var locationManager: LocationManagerProtocol
    
   required init(view: MapViewControllerProtocol, networkService: NetworkServiceProtokol, locationManager: LocationManagerProtocol) {
       self.networkService = networkService
       self.locationManager = locationManager
       super.init()
       self.view = view
    }
    
    func setUserLocation() {
        locationManager.updateLocation()
        locationManager.location = { [weak self] result in
            self?.view?.updateViewSetCenter(location: result)
        }
    }

}
