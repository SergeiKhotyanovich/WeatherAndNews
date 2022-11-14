
import UIKit
import SnapKit

protocol weatherViewControllerProtocol: AnyObject {
    func setAnotherView()
    func success()
    func failure(error: Error)
    func successForecasView()
    func successSectionCount(numberOfSections:[String], numberOfRows:[String])
    func successGettingData(currentWeatherViewModel: CurrentWeatherCollectionViewModel, forecastWeatherViewModel: ForecastWeatherViewModel)
    func showAlert()
}

class WeatherViewController: UIViewController, weatherViewControllerProtocol {
    
    public var presenter: weatherPresenterProtocol!
    private var forecastViewModel: ForecastWeatherViewModel?
    
    let titleNameLabel = UILabel()
    let searchButoon = UIButton(type: .system)
    let updateLocationButton = UIButton()
    var currentView = CurrentView(frame: .zero)
    var forecastView = ForecastView(frame: .zero)
    var searchView = SearchView(frame: .zero)
    
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
    
    var loadViewIndicator: UIActivityIndicatorView = {
        var spiner = UIActivityIndicatorView(style: .large)
        spiner.color = Color.secondary
        spiner.hidesWhenStopped = true
        return spiner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([
            titleNameLabel,searchButoon,
            updateLocationButton,searchView,
            pageControll, currentView,
            forecastView, blurView, loadViewIndicator
        ])
        
        setupLayout()
        setupStyle()
        
        searchView.backgroundColor = Color.main
        
        view.backgroundColor = UIColor(named: "main")
        
        updateLocationButton.addTarget(self, action: #selector(updateWeatherButtonPressed), for: .touchUpInside)
        pageControll.addTarget(self, action: #selector(changeScreenWeather), for: .allEvents)
        searchButoon.addTarget(self, action: #selector(animateHidenSearchView), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateIsHidenSearchView))
        blurView.addGestureRecognizer(tap)
        
        searchView.updateSearchButton.addTarget(self, action: #selector(searchUpdateButtonPress), for: .touchUpInside)
        
        forecastView.isHidden = true
        searchView.alpha = 0
        blurView.alpha = 0
        
        loadViewIndicator.center = view.center
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
    
    @objc func animateHidenSearchView() {
        UIView.animate(withDuration: 0.3) {
            self.searchView.alpha = 1
            self.pageControll.alpha = 0
            self.blurView.alpha = 1
        }
    }
    
    @objc func animateIsHidenSearchView() {
        UIView.animate(withDuration: 0.3) {
            self.searchView.alpha = 0
            self.blurView.alpha = 0
            self.pageControll.alpha = 1
        }
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
            make.top.equalToSuperview()
            make.right.left.equalToSuperview()
            make.bottom.equalTo(pageControll)
        }
        
        blurView.snp.makeConstraints { make in
            make.top.equalTo(pageControll).inset(35)
            make.right.left.bottom.equalToSuperview()
        }
//        spiner.snp.makeConstraints { make in
//            make.top.right.left.bottom.equalToSuperview()
//        }
    }
    
    //MARK: FUNC
    
    @objc func searchUpdateButtonPress() {
        guard let cityName = searchView.searchTextField.text else { return }
        print(cityName)
        self.presenter.getSearchCity(city: cityName)
        showLoadViewIndicator()
    }
    
    
    @objc func updateWeatherButtonPressed() {
        self.presenter.updateWeatherButtonPressed()
        showLoadViewIndicator()
    }
    
    @objc func setAnotherView() {
//        self.presenter.showFitstView()
        
    }
    
    func success() {
        
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    func successForecasView(){
        self.presenter.getDayOfTheWeek()
    }
    
    func successSectionCount(numberOfSections:[String], numberOfRows:[String]) {
        forecastView.updateSectionCount(sectionsCount: numberOfSections, rowsCount: numberOfRows)
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
    
    func successGettingData(currentWeatherViewModel: CurrentWeatherCollectionViewModel, forecastWeatherViewModel: ForecastWeatherViewModel) {
        currentView.updateView(model: currentWeatherViewModel)
        forecastView.updateView(model: forecastWeatherViewModel)
        hideLoadViewIndicator()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "This city doesn't exist", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.hideLoadViewIndicator()
            self.animateIsHidenSearchView()
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
