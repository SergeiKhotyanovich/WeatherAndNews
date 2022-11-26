
import Foundation

final class MapBuilder {
    static func build() -> MapViewController {
        let view = MapViewController()
        let networkService = NetworkService()
        let locationManager = LocationManager()
        
        let presenter = MapPresenter(view: view, networkService: networkService, locationManager: locationManager)
        
        view.presenter = presenter
        return view
    }
}
