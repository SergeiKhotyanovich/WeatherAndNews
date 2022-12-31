
import UIKit
import SnapKit

protocol WeatherViewControllerProtocol: AnyObject {
    func failure(error: Error)
    func successForecasView()
    func successSectionCount(numberOfSections:[String], numberOfRowsAt:[Int])
    func successGettingData(currentWeatherViewModel: CurrentWeatherViewModel, forecastWeatherViewModel: ForecastWeatherViewModel)
    func showAlert()
}

class WeatherViewController: UIViewController, WeatherViewControllerProtocol {
    
    var presenter: weatherPresenterProtocol!
    private var forecastViewModel: ForecastWeatherViewModel?
    
    private let titleNameLabel = UILabel()
    private let searchButoon = UIButton(type: .system)
    private let updateLocationButton = UIButton()
    private let notificationCenter = NotificationCenter.default
    private var searchView = SearchView(frame: .zero)
    var currentView = CurrentView(frame: .zero)
    var forecastView = ForecastView(frame: .zero)
    
    private let settingButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = Color.secondary
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    lazy var pageControll:UISegmentedControl = {
        let items = ["Current", "Forecast"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = Color.secondary
        view.backgroundColor = .gray
        return view
    }()
    
    private var loadViewIndicator: UIActivityIndicatorView = {
        var spiner = UIActivityIndicatorView(style: .large)
        spiner.color = Color.secondary
        spiner.hidesWhenStopped = true
        return spiner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        setupStyle()
        setupTarget()
    }
    
    func setupUI() {
        view.addSubviews([
            titleNameLabel,searchButoon,
            updateLocationButton,searchView,
            pageControll, currentView,
            forecastView, blurView, loadViewIndicator,
            settingButton
        ])
        searchView.backgroundColor = Color.main
        view.backgroundColor = UIColor(named: "main")
        
        forecastView.isHidden = true
        searchView.alpha = 0
        searchView.backgroundColor = Color.main
        blurView.alpha = 0
        loadViewIndicator.center = view.center
        presenter.updateWeatherButtonPressed(temperature: UserTemperature.shared.userTemperature,
                                             language: UserLanguage.shared.userLanguage)
    }
    
    func setupTarget() {
        updateLocationButton.addTarget(self,
                                       action: #selector(updateWeatherButtonPressed),
                                       for: .touchUpInside)
        pageControll.addTarget(self,
                               action: #selector(changeScreenWeather),
                               for: .allEvents)
        searchButoon.addTarget(self,
                               action: #selector(animateHidenSearchView),
                               for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(animateIsHidenSearchView))
        blurView.addGestureRecognizer(tap)
        
        searchView.updateSearchButton.addTarget(self,
                                                action: #selector(searchUpdateButtonPress),
                                                for: .touchUpInside)
        
        searchView.closeButton.addTarget(self,
                                         action: #selector(animateIsHidenSearchView),
                                         for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(goToSettingVC), for: .touchUpInside)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(mapViewWeatherLocation) ,
                                       name: NSNotification.Name.mapViewWeatherLocation,
                                       object: nil)
    }
    
    //MARK: STYLE
    
    func setupStyle() {
        titleNameLabelStyle()
        searchButoonStyle()
        locationButoonStyle()
    }
    
    func titleNameLabelStyle() {
        titleNameLabel.text = "Weather"
        titleNameLabel.textAlignment = .center
        titleNameLabel.textColor = Color.secondary
        titleNameLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 60)
        titleNameLabel.adjustsFontSizeToFitWidth = true
        titleNameLabel.minimumScaleFactor = 0.2
    }
    
    func searchButoonStyle() {
        searchButoon.contentVerticalAlignment = .fill
        searchButoon.contentHorizontalAlignment = .fill
        searchButoon.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButoon.tintColor = Color.secondary
        searchButoon.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
    }
    
    func locationButoonStyle() {
        updateLocationButton.contentVerticalAlignment = .fill
        updateLocationButton.contentHorizontalAlignment = .fill
        updateLocationButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        updateLocationButton.tintColor = Color.secondary
        updateLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
    }
    
    //MARK: LAYOUT
    
    func setupLayout() {
        
        titleNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(view.frame.width / 2 - 60)
            make.right.equalToSuperview().inset(view.frame.width / 2 - 60)
            make.top.equalToSuperview().inset(15)
        }
        
        searchButoon.snp.makeConstraints { make in
            make.left.equalTo(titleNameLabel.snp.right).offset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        updateLocationButton.snp.makeConstraints { make in
            make.left.equalTo(searchButoon.snp.right).offset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        pageControll.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(40)
            make.top.equalTo(titleNameLabel.snp.bottom)
        }
        
        currentView.snp.makeConstraints { make in
            make.top.equalTo(pageControll.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        forecastView.snp.makeConstraints { make in
            make.top.equalTo(pageControll.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.top.equalTo(pageControll).inset(35)
            make.right.left.bottom.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints { make in
            make.left.equalTo(updateLocationButton.snp.right).offset(15)
            make.top.equalToSuperview().inset(50)
            make.height.width.equalTo(25)
        }
    }
    
    //MARK: FUNC
    
    @objc func searchUpdateButtonPress() {
        guard let cityName = searchView.searchTextField.text else { return }
        self.presenter.getSearchCity(city: cityName,
                                     temperature: UserTemperature.shared.userTemperature,
                                     language: UserLanguage.shared.userLanguage)
        showLoadViewIndicator()
    }
    
    
    @objc func updateWeatherButtonPressed() {
        self.presenter.updateWeatherButtonPressed(temperature: UserTemperature.shared.userTemperature,
                                                  language: UserLanguage.shared.userLanguage)
        showLoadViewIndicator()
    }
    
    @objc func mapViewWeatherLocation(notification: Notification) {
        showLoadViewIndicator()
        guard let coordinate = notification.userInfo as? [String : Location] else { return }
        guard let location = coordinate["location"] else { return }
        presenter.updateMapViewWeatherButtonPressed(location: location, temperature: UserTemperature.shared.userTemperature,
                                                    language: UserLanguage.shared.userLanguage)
    }
    
    @objc func animateHidenSearchView() {
        UIView.animate(withDuration: 0.3) {
            self.searchView.alpha = 1
            self.pageControll.alpha = 0
            self.currentView.alpha = 0
            self.forecastView.alpha = 0
            self.settingButton.alpha = 0
        }
    }
    
    @objc func animateIsHidenSearchView() {
        UIView.animate(withDuration: 0.3) {
            self.searchView.alpha = 0
            self.pageControll.alpha = 1
            self.currentView.alpha = 1
            self.forecastView.alpha = 1
            self.settingButton.alpha = 1
        }
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    func successForecasView(){
        self.presenter.getDayOfTheWeek()
    }
    
    func successSectionCount(numberOfSections:[String], numberOfRowsAt:[Int]) {
        forecastView.updateSectionCount(sectionsCount: numberOfSections, rowsCount: numberOfRowsAt)
        animateIsHidenSearchView()
    }
    
    func showLoadViewIndicator() {
        
        UIView.animate(withDuration: 0.2) {
            self.blurView.alpha = 1
            self.loadViewIndicator.startAnimating()
        }
    }
    
    func hideLoadViewIndicator() {
        UIView.animate(withDuration: 0.1) {
            self.blurView.alpha = 0
            self.loadViewIndicator.stopAnimating()
        }
    }
    
    @objc func changeScreenWeather(){
        switch pageControll.selectedSegmentIndex{
        case 0:
            currentView.isHidden = false
            forecastView.isHidden = true
        case 1:
            currentView.isHidden = true
            forecastView.isHidden = false
        default:
            return
        }
    }
    
    func successGettingData(currentWeatherViewModel: CurrentWeatherViewModel, forecastWeatherViewModel: ForecastWeatherViewModel) {
        currentView.updateView(model: currentWeatherViewModel)
        forecastView.updateView(model: forecastWeatherViewModel)
        searchView.popularCitiesCollectionView.reloadData()
        hideLoadViewIndicator()
    }
    
    func showAlert() {
        blurView.alpha = 0
        loadViewIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: "This city doesn't exist", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    @objc func goToSettingVC() {
        let vc = SettingBuilder.build()
        
        
        if UserTemperature.shared.userTemperature == "imperial" {
            vc.temperatureSegmentControl.selectedSegmentIndex = 1
        }
        
        if UserLanguage.shared.userLanguage == "ru" {
            vc.languageSegmentControl.selectedSegmentIndex = 1
        }
        
        if UserTheme.shared.userTheme == "Dark" {
            vc.themeSegmentControl.selectedSegmentIndex = 1
        }
        
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
