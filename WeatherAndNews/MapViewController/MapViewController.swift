
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
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    var location: Location? = nil
    var locationCenter: CLLocation?
    private let notificationCenter = NotificationCenter.default
    
    private let showWeatherButton: UIButton = {
        let showWeatherButton = UIButton(type: .custom)
        showWeatherButton.backgroundColor = Color.element
        showWeatherButton.setTitle("Show weather", for: .normal)
        showWeatherButton.setTitleColor(Color.secondary, for: .normal)
        showWeatherButton.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 18)
        showWeatherButton.layer.cornerRadius = 10
        return showWeatherButton
    }()
    
    private let setCameraCenterView: UIButton = {
        let showWeatherButton = UIButton(type: .custom)
        showWeatherButton.backgroundColor = Color.element
        showWeatherButton.contentMode = .scaleToFill
        showWeatherButton.setImage(UIImage(systemName: "location"), for: .normal)
        showWeatherButton.tintColor = Color.secondary
        showWeatherButton.layer.cornerRadius = 21
        return showWeatherButton
    }()
    
    private let centerView: UIView = {
        let centerView = UIView()
        centerView.backgroundColor = .red
        centerView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 10, height: 10))
        centerView.layer.cornerRadius = 5
        return centerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupDelegat()
    }
    
    func setupUI() {
        view.addSubviews([
            mapView,
            centerView,
            showWeatherButton,
            setCameraCenterView
        ])
        
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        showWeatherButton.addTarget(self, action: #selector(mapWeatherButtonPressed), for: .touchUpInside)
        setCameraCenterView.addTarget(self, action: #selector(setCameraCenterViewPressed), for: .touchUpInside)
    }
    
    func setupDelegat() {
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    //MARK: LAYOUT
    
    func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerView.center = view.center
        
        showWeatherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(130)
            make.height.equalTo(35)
        }
        
        setCameraCenterView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(showWeatherButton.snp.top).inset(-12)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
    }
    
    //MARK: STYLE
    
    func setupStyle() {
//        mapView.eleme
    }
    
    //MARK: FUNC
    
    @objc func mapWeatherButtonPressed() {
        guard let location = location else { return }
        notificationCenter.post(name: NSNotification.Name.mapViewWeatherLocation, object: self, userInfo: ["location":location])
    }
    
    @objc func setCameraCenterViewPressed() {
        guard let location = locationCenter?.coordinate else {
            return
        }
        mapView.setCenter(location, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationCenter = locations.first

    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
        location = Location(longitude: String(mapView.centerCoordinate.longitude), lotitude: String(mapView.centerCoordinate.latitude))
        
    }
    
}
