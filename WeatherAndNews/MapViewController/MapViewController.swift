
import UIKit
import MapKit
import SnapKit
import CoreLocation

extension NSNotification.Name {
    
    static let mapViewWeatherLocation = NSNotification.Name.init("mapViewWeatherLocation")
}

protocol MapViewControllerProtocoll: NSObject {
    
}

class MapViewController: UIViewController, MapViewControllerProtocoll {
    
    public var presenter: MapPresenterProtokol!
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var longitude = ""
    var latitude = ""
    var location: Location? = nil
    let notificationCenter = NotificationCenter.default
    
    let showWeatherButton: UIButton = {
        let showWeather = UIButton(type: .custom)
        showWeather.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 20))
        showWeather.backgroundColor = Color.element
        showWeather.setTitle("Show weather", for: .normal)
        showWeather.setTitleColor(Color.secondary, for: .normal)
        showWeather.layer.cornerRadius = 10
        return showWeather
    }()
    
    let centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = Color.secondary
        centerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: 15))
        centerView.layer.cornerRadius = 7
        return centerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([
            mapView,
            centerView,
            showWeatherButton
        ])
        
        setupLayout()
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        showWeatherButton.addTarget(self, action: #selector(mapWeatherButtonPressed), for: .touchUpInside)
    }
    
    //MARK: LAYOUT
    
    func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerView.center = view.center
        
        showWeatherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(10)
        }
    }
    
    //MARK: STYLE
    
    func setupStyle() {
        
    }
    
    //MARK: FUNC
    
    @objc func mapWeatherButtonPressed() {
        
        guard let location = location else { return }
        notificationCenter.post(name: NSNotification.Name.mapViewWeatherLocation, object: self, userInfo: ["location":location])
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        mapView.setCenter(location.coordinate, animated: true)
    }
}
 
extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        latitude = String(mapView.centerCoordinate.latitude)
        longitude = String(mapView.centerCoordinate.longitude)
        
       location = Location(longitude: String(mapView.centerCoordinate.longitude), lotitude: String(mapView.centerCoordinate.latitude))
        
    }
    
}
