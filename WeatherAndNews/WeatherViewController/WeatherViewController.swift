//
//  WeatherViewController.swift
//  WeatherAndNews
//
//  Created by Сергей Хотянович on 31.03.22.
//

import UIKit
import SnapKit
import CoreLocation

protocol weatherViewControllerProtocol: AnyObject {
    func setAnotherView()
    func success()
    func failure(error: Error)
    func updateTableView()
    
//    func apdateView()
}

class WeatherViewController: UIViewController,weatherViewControllerProtocol {
 
    public var presenter: weatherPresenterProtocol!
    
    let weatherPicture = UIImageView()
    let tempLabel = UILabel()
    let sityLabel = UILabel()
    let weatherLabel = UILabel()
    let titleNameLabel = UILabel()
    let searchButoon = UIButton(type: .system)
    let locationButoon = UIButton()
    var currentView = UIView()
    var forecastView = UIView()
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    let cellSpacingHeight: CGFloat = 40

    lazy var pageControll:UISegmentedControl = {
        let items = ["Current", "Forecast"]
        let view = UISegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = Color.secondary
        view.backgroundColor = .gray
        return view
    }()
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(CurrentCollectionViewCell.self, forCellWithReuseIdentifier: CurrentCollectionViewCell.identifier)
        return view
    }()
    
    var flag = 0
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([titleNameLabel,searchButoon,locationButoon,pageControll,currentView,forecastView])
        currentView.addSubviews([tempLabel,weatherPicture,sityLabel,weatherLabel,collectionView])
        forecastView.addSubviews([tableView])
        
        setupLayout()
        setupStyle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        setupCollectionViewLayout()

    
        view.backgroundColor = UIColor(named: "main")
        
        locationButoon.addTarget(self, action: #selector(updateWeatherButtonPressed), for: .touchUpInside)
        pageControll.addTarget(self, action: #selector(changeScreenWeather), for: .allEvents)
        
        currentView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
    }
    
    //MARK: STYLE
    
    func setupStyle() {
        titleNameLabelStyle()
        searchButoonStyle()
        locationButoonStyle()
        tempLabelStyle()
        weatherPictureStyle()
        sityLabelStyle()
        weatherLabelStyle()
        tableViewStyle()
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
        locationButoon.contentVerticalAlignment = .fill
        locationButoon.contentHorizontalAlignment = .fill
        locationButoon.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        locationButoon.tintColor = Color.secondary
        locationButoon.setImage(UIImage(systemName: "location"), for: .normal)
    }
    
    func tempLabelStyle() {
       
        tempLabel.textAlignment = .center
        tempLabel.textColor = Color.secondary
        tempLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 300)
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.01
        tempLabel.numberOfLines = 0
    }
    
    func sityLabelStyle() {
        sityLabel.text = "Minsk"
        sityLabel.textAlignment = .center
        sityLabel.textColor = Color.secondary
        sityLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 100)
        sityLabel.adjustsFontSizeToFitWidth = true
        sityLabel.minimumScaleFactor = 0.2
    }
    
    func weatherLabelStyle() {
        weatherLabel.text = "Sunny"
        weatherLabel.textAlignment = .center
        weatherLabel.textColor = Color.secondary
        weatherLabel.font = UIFont(name: "ChalkboardSE-Regular", size: 100)
        weatherLabel.adjustsFontSizeToFitWidth = true
        weatherLabel.minimumScaleFactor = 0.01
        weatherLabel.numberOfLines = 0
    }
    
    func weatherPictureStyle() {
        weatherPicture.image = UIImage(systemName:"sun.max")
        weatherPicture.tintColor = Color.secondary
    }
    
    func tableViewStyle() {
        tableView.backgroundColor = UIColor(named: "main")
    }
    
    private func setupCollectionViewLayout() {
        collectionView.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout()
        if view.frame.height == 667{
                    layout.scrollDirection = .horizontal
                    layout.itemSize = CGSize(
                        width: (self.collectionView.frame.width / 3 - 6),
                        height: (self.collectionView.frame.height  - 150)
                    )
                }else if view.frame.height < 667 {
                    layout.scrollDirection = .horizontal
                    layout.itemSize = CGSize(
                        width: (self.collectionView.frame.width / 3 - 6),
                        height: (self.collectionView.frame.height / 1.5 )
                    )
                }else{
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(
                width: (self.collectionView.frame.width / 3 - 6),
                height: (self.collectionView.frame.height / 3 - 32)
            )
                }
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
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
        
        locationButoon.snp.makeConstraints { make in
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
        
        tempLabel.snp.makeConstraints { make in
            make.width.height.equalTo(view.frame.width/2)
            make.top.left.equalTo(currentView)
        }
        
        weatherPicture.snp.makeConstraints { make in
            make.width.equalTo(view.frame.width/2)
            make.height.equalTo(view.frame.width/2 - 20)
            make.right.equalToSuperview()
            make.top.equalTo(currentView).inset(20)
        }
        
        sityLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(currentView.snp.centerX)
            make.height.equalTo(view.frame.width/7)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherPicture.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(currentView.snp.centerX)
            make.height.equalTo(view.frame.width/7)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sityLabel.snp.bottom).offset(16)
            make.right.left.equalTo(currentView).inset(16)
            make.bottom.equalTo(currentView).inset(4)
        }

        forecastView.snp.makeConstraints { make in
            make.top.equalTo(pageControll.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
    }
    
    //MARK: FUNC
    
    @objc func updateWeatherButtonPressed() {
        self.presenter.updateWeatherButtonPressed()
    }
    
    @objc func setAnotherView() {
        self.presenter.showFitstView()
    }
    
    func success() {
        sityLabel.text = presenter.weather?.name
        weatherLabel.text = DataSource.weatherIDs[presenter.weather?.weather[0].id ?? 0]
        guard let tempLabelNonOpt = presenter.weather?.main.temp else {return}
        tempLabel.text = "\(Int(tempLabelNonOpt.rounded()))°C"
        collectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
    
    func updateTableView(){
        tableView.reloadData()
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
    
//    func firstWeekday(day: Int) -> String {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        if let nonOptdate = presenter.weatherForecast?.list[day].dtTxt{
//            let date = dateFormatter.date(from:nonOptdate)!
//            let calendar = Calendar.current
//            let components = calendar.component(.weekday, from: date)
//            switch components {
//                case 1:
//                    flag = 1
//                    return "Sunday"
//                case 2:
//                    flag = 2
//                    return "Monday"
//                case 3:
//                    flag = 3
//                    return "Tueday"
//                case 4:
//                    flag = 4
//                    return "Wednesday"
//                case 5:
//                    flag = 5
//                    return "Thuday"
//                case 6:
//                    flag = 6
//                    return "Friday"
//                case 7:
//                    flag = 7
//                    return "Saturday"
//                default:
//                    print("Error fetching days")
//                    return "Day"
//        }
//            }
//        return ""
//            }
//    func nextDay() -> String{
//
//        if flag == 1{
//            flag = flag + 1
//            return "Monday"
//        }else if flag == 2{
//            flag = flag + 1
//            return "Tueday"
//        }
//        else if flag == 3{
//            flag = flag + 1
//            return "Wednesday"
//        }
//        else if flag == 4{
//            flag = flag + 1
//            return "Thuday"
//        }
//        else if flag == 5{
//            flag = flag + 1
//            return "Friday"
//        }
//        else if flag == 6{
//            flag = flag + 1
//            return "Saturday"
//        }
//        else if flag == 7{
//            flag = 1
//            return "Sunday"
//        }
//        return ""
//    }
}

//MARK: extension currentView

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCollectionViewCell.identifier, for: indexPath) as! CurrentCollectionViewCell
        switch indexPath.row{
        case 0:
            if let pressure = presenter.weather?.main.pressure{
                cell.label.text = "\(pressure)hPa"
            }
            cell.imageView.image = UIImage(systemName: "thermometer")
        case 3:
            if let humidity = presenter.weather?.main.humidity{
                cell.label.text = "\(humidity)%"
            }
           
            cell.imageView.image = UIImage(systemName: "humidity")
        case 6:
            if let speed = presenter.weather?.wind.speed{
                cell.label.text = "\(speed)m/s"
            }
            cell.imageView.image = UIImage(systemName: "wind")
        case 1:
            if let visibility = presenter.weather?.visibility{
                cell.label.text = "\(visibility)M"
            }
            cell.imageView.image = UIImage(systemName: "eye.fill")
        case 4:
            if let clouds = presenter.weather?.clouds.all{
                cell.label.text = "\(clouds)%"
            }
            cell.imageView.image = UIImage(systemName: "smoke.fill")
        case 7:
            if let feelsLike = presenter.weather?.main.feelsLike{
                cell.label.text = "\(feelsLike)°C"
               
            }
            cell.imageView.image = UIImage(systemName: "figure.stand")
        case 2:
            if let rain = presenter.weather?.rain?.the3H{
                cell.label.text = "\(rain)mm"
            }else{
                cell.label.text = "0mm"
            }
            cell.imageView.image = UIImage(systemName: "cloud.heavyrain")
        case 5:
            if let tempMax = presenter.weather?.main.tempMax{
                cell.label.text = "\(tempMax)°C"
            }
            cell.imageView.image = UIImage(systemName: "sun.max.fill")
        case 8:
            if let tempMin = presenter.weather?.main.tempMin{
                cell.label.text = "\(tempMin)°C"
            }
            cell.imageView.image = UIImage(systemName: "sun.min")
        default:
            cell.label.text = presenter.weather?.base
        }
         
        return cell
    }
    
}

//MARK: extension ForecustView

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.forecastWeatherView?.collectionViewForHourModels.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath)

        cell.backgroundColor = Color.element
        cell.layer.borderColor = Color.main?.cgColor
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
 
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "sdfsdf"
        }
    
}
