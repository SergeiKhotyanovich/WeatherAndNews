
import UIKit
import MapKit
import SnapKit
import CoreLocation

extension NSNotification.Name {
    
    static let mapViewWeatherLocation = NSNotification.Name.init("mapViewWeatherLocation")
}

protocol MapViewControllerProtocol: NSObject {
    func goToUserLocationButtonPressed()
    func updateViewSetCenter(location: Location)
}

class MapViewController: UIViewController, MapViewControllerProtocol {
    
    var presenter: MapPresenterProtokol!
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    var location: Location? = nil
    var locationCenter: CLLocation?
    private let notificationCenter = NotificationCenter.default
    
    private let showWeatherButton: UIButton = {
        let showWeatherButton = UIButton(type: .custom)
        showWeatherButton.backgroundColor = Color.element
        showWeatherButton.setTitle("Show weather".localized(), for: .normal)
        showWeatherButton.setTitleColor(Color.secondary, for: .normal)
        showWeatherButton.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 18)
        showWeatherButton.layer.cornerRadius = 10
        return showWeatherButton
    }()
    
    private let goToUserLocationButton: UIButton = {
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
        centerView.layer.cornerRadius = 5
        return centerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupDelegat()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        centerView.layer.cornerRadius = centerView.frame.width / 2
        
    }
    
    func setupUI() {
        view.addSubviews([
            mapView,
            centerView,
            showWeatherButton,
            goToUserLocationButton
        ])
        
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true

        showWeatherButton.addTarget(self, action: #selector(mapWeatherButtonPressed), for: .touchUpInside)
        goToUserLocationButton.addTarget(self, action: #selector(goToUserLocationButtonPressed), for: .touchUpInside)
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
        
        centerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(view.frame.width/2 - 5)
            make.bottom.equalToSuperview().inset(view.frame.height/2 + 13)
            make.top.equalToSuperview().inset(view.frame.height/2 - 23)
        }
        
        showWeatherButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(130)
            make.height.equalTo(35)
        }
        
        goToUserLocationButton.snp.makeConstraints { make in
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
    
    @objc func goToUserLocationButtonPressed() {
        presenter.setUserLocation()
    }
    
    func updateViewSetCenter(location: Location) {

        mapView.setCenter(CLLocationCoordinate2D(latitude: Double(location.lotitude) ?? 10, longitude: Double(location.longitude) ?? 10), animated: true)
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
